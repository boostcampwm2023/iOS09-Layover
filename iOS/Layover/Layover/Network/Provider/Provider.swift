//
//  Provider.swift
//  Layover
//
//  Created by kong on 2023/11/13.
//

import Foundation
import UniformTypeIdentifiers

import OSLog

protocol ProviderType {
    func request<R: Decodable, E: RequestResponsable>(with endPoint: E, authenticationIfNeeded: Bool, retryCount: Int) async throws -> R where E.Response == R
    func request(url: URL) async throws -> Data
    func request(url: String) async throws -> Data
    func upload(data: Data, contentType: String, to presignedURL: String, method: HTTPMethod) async throws -> Data
    func upload(fromFile: URL,
                to url: String,
                method: HTTPMethod,
                sessionTaskDelegate: URLSessionTaskDelegate?,
                delegateQueue: OperationQueue?) async throws -> Data
}

extension ProviderType {
    func request<R: Decodable, E: RequestResponsable>(with endPoint: E,
                                                      authenticationIfNeeded: Bool = true,
                                                      retryCount: Int = 2) async throws -> R where E.Response == R {
        return try await request(with: endPoint,
                                 authenticationIfNeeded: authenticationIfNeeded,
                                 retryCount: retryCount)
    }

    func upload(data: Data, contentType: String, to presignedURL: String, method: HTTPMethod = .PUT) async throws -> Data {
        return try await upload(data: data,
                                contentType: contentType,
                                to: presignedURL,
                                method: method)
    }

    func upload(from fileURL: URL, to url: String, method: HTTPMethod = .PUT) async throws -> Data {
        return try await upload(from: fileURL, to: url, method: method)
    }

    func upload(fromFile: URL,
                to url: String,
                method: HTTPMethod = .PUT,
                sessionTaskDelegate: URLSessionTaskDelegate? = nil,
                delegateQueue: OperationQueue? = nil) async throws -> Data {
        return try await upload(fromFile: fromFile,
                                to: url,
                                method: method,
                                sessionTaskDelegate: sessionTaskDelegate,
                                delegateQueue: delegateQueue)
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
    func upload(data: Data, contentType: String, to presignedURL: String, method: HTTPMethod = .PUT) async throws -> Data {
        guard let url = URL(string: presignedURL) else { throw NetworkError.components }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.httpMethod = method.rawValue
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")

        let (data, response) = try await session.upload(for: request, from: data)
        try self.checkStatusCode(of: response)
        return data
    }

    func upload(from fileURL: URL, to url: String, method: HTTPMethod = .PUT) async throws -> Data {
        guard let url = URL(string: url) else { throw NetworkError.components }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.httpMethod = method.rawValue

        let (data, response) = try await session.upload(for: request, fromFile: fileURL)
        try self.checkStatusCode(of: response)
        return data
    }

    // 동영상 업로드용
    func upload(fromFile: URL,
                to url: String,
                method: HTTPMethod = .PUT,
                sessionTaskDelegate: URLSessionTaskDelegate? = nil,
                delegateQueue: OperationQueue? = nil) async throws -> Data {
        guard let url = URL(string: url) else { throw NetworkError.components }
        guard let mimeType = UTType(filenameExtension: fromFile.pathExtension)?.preferredMIMEType else { throw NetworkError.unknown }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.httpMethod = method.rawValue
        request.setValue(mimeType, forHTTPHeaderField: "Content-Type")
        let (data, response) = try await session.upload(for: request,
                                                        fromFile: fromFile,
                                                        delegate: sessionTaskDelegate)
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
