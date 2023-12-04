//
//  Provider.swift
//  Layover
//
//  Created by kong on 2023/11/13.
//

import Foundation
import OSLog

protocol ProviderType {
    func request<R: Decodable, E: RequestResponsable>(with endPoint: E, authenticationIfNeeded: Bool, retryCount: Int) async throws -> R where E.Response == R
    func request(url: URL) async throws -> Data
    func request(url: String) async throws -> Data
}

extension ProviderType {
    func request<R: Decodable, E: RequestResponsable>(with endPoint: E,
                                                      authenticationIfNeeded: Bool = true,
                                                      retryCount: Int = 2) async throws -> R where E.Response == R {
        return try await request(with: endPoint,
                                 authenticationIfNeeded: authenticationIfNeeded,
                                 retryCount: retryCount)
    }
}

class Provider: ProviderType {

    // MARK: - Properties

    private let session: URLSession
    private let authManager: AuthManagerProtocol
    private let loginEndPointFactory: LoginEndPointFactory

    // MARK: Initializer

    init(session: URLSession = URLSession.shared,
         authManager: AuthManagerProtocol = AuthManager.shared,
         loginEndPointFactory: LoginEndPointFactory = DefaultLoginEndPointFactory()) {
        self.session = session
        self.authManager = authManager
        self.loginEndPointFactory = loginEndPointFactory
    }

    // MARK: Methods

    func request<R: Decodable, E: RequestResponsable>(with endPoint: E,
                                                      authenticationIfNeeded: Bool,
                                                      retryCount: Int) async throws -> R where E.Response == R {

        var urlRequest = try endPoint.makeURLRequest()

        if authenticationIfNeeded {
            if let token = authManager.accessToken {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            } else {
                guard await refreshTokenIfNeeded(), let newToken = authManager.accessToken else {
                    await MainActor.run {
                        NotificationCenter.default.post(name: .refreshTokenDidExpired, object: nil)
                    }
                    throw NetworkError.urlRequest
                }
                urlRequest.setValue("Bearer \(newToken)", forHTTPHeaderField: "Authorization")
            }
        }

        let (data, response) = try await session.data(for: urlRequest)

        do {
            try self.checkStatusCode(of: response)
        } catch NetworkError.server(let error) {
            if case .unauthorized = error, authenticationIfNeeded {
                guard retryCount > 0, await refreshTokenIfNeeded() else {
                    authManager.logout()
                    await MainActor.run {
                        NotificationCenter.default.post(name: .refreshTokenDidExpired, object: nil)
                    }
                    throw NetworkError.server(error)
                }

                return try await request(with: endPoint, authenticationIfNeeded: authenticationIfNeeded, retryCount: retryCount - 1)
            } else {
                throw NetworkError.server(error)
            }
        }

        return try data.decode()
    }

    func request(url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        try self.checkStatusCode(of: response)
        return data
    }

    func request(url: String) async throws -> Data {
        guard let url = URL(string: url) else { throw NetworkError.components }
        let (data, response) = try await session.data(from: url)
        try self.checkStatusCode(of: response)
        return data
    }

    // 이미지 업로드용
    func upload(data: Data, to url: String, method: HTTPMethod = .PUT) async throws -> Data {
        guard let url = URL(string: url) else { throw NetworkError.components }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = data

        let (data, response) = try await session.upload(for: request, from: data)
        try self.checkStatusCode(of: response)
        return data
    }

    func backgroundUpload(fromFile: URL, to url: String, method: HTTPMethod = .PUT) async throws -> Data {
        guard let url = URL(string: url) else { throw NetworkError.components }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        let backgroundSession = URLSession(configuration: .background(withIdentifier: UUID().uuidString))
        
        let (data, response) = try await session.upload(for: request, fromFile: fromFile)
        try self.checkStatusCode(of: response)
        return data
    }

    private func checkStatusCode(of response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }

        guard 200...299 ~= response.statusCode else {
            let serverError = ServerError(rawValue: response.statusCode) ?? .unknown
            throw NetworkError.server(serverError)
        }
    }

    private func refreshTokenIfNeeded() async -> Bool {
        guard let refreshToken = authManager.refreshToken else { return false }
        let endPoint = loginEndPointFactory.makeTokenRefreshEndPoint(with: refreshToken)
        do {
            let response = try await request(with: endPoint, authenticationIfNeeded: false, retryCount: 0)
            authManager.accessToken = response.data?.accessToken
            authManager.refreshToken = response.data?.refreshToken
            return true
        } catch {
            os_log(.error, "refresh token error: %@", error.localizedDescription)
            return false
        }
    }
}

extension Data {
    func decode<T: Decodable>() throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: self)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}
