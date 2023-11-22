//
//  Provider.swift
//  Layover
//
//  Created by kong on 2023/11/13.
//

import Foundation

protocol ProviderType {
    func request<R: Decodable, E: RequestResponsable>(with endPoint: E, authenticationIfNeeded: Bool, retryCount: Int) async throws -> R where E.Response == R
    func request(url: URL) async throws -> Data
    func request(url: String) async throws -> Data
}

class Provider: ProviderType {

    private let session: URLSession
    private let authManager: AuthManagerProtocol

    init(session: URLSession = URLSession.shared, authManager: AuthManagerProtocol = AuthManager.shared) {
        self.session = session
        self.authManager = authManager
    }

    func request<R: Decodable, E: RequestResponsable>(with endPoint: E,
                                                      authenticationIfNeeded: Bool = true,
                                                      retryCount: Int = 2) async throws -> R where E.Response == R {

        var urlRequest = try endPoint.makeURLRequest()

        if authenticationIfNeeded {
            if let token = authManager.accessToken {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }

        let (data, response) = try await session.data(for: urlRequest)

        do {
            try self.checkStatusCode(of: response)
        } catch NetworkError.server(let error) {
            if case .unauthorized = error {
                guard retryCount > 0 else {
                    throw NetworkError.server(error)
                }

                // TODO: refresh 해야함

                return try await request(with: endPoint, authenticationIfNeeded: authenticationIfNeeded, retryCount: retryCount - 1)
            }
        }

        return try data.decode()
    }

    public func request(url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        try self.checkStatusCode(of: response)
        return try data.decode()
    }

    public func request(url: String) async throws -> Data {
        guard let url = URL(string: url) else { throw NetworkError.components }
        let (data, response) = try await session.data(from: url)
        try self.checkStatusCode(of: response)
        return try data.decode()
    }

    func checkStatusCode(of response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }

        guard 200...299 ~= response.statusCode else {
            let serverError = ServerError(rawValue: response.statusCode) ?? .unknown
            throw NetworkError.server(serverError)
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
