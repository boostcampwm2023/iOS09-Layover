//
//  Provider.swift
//  Layover
//
//  Created by kong on 2023/11/13.
//

import Foundation

protocol ProviderType {
    func request<R: Decodable, E: RequestResponsable>(with endPoint: E) async throws -> R where E.Response == R
    func request(url: URL) async throws -> Data
    func request(url: String) async throws -> Data
}

class Provider: ProviderType {

    let session: URLSession

    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    public func request<R: Decodable, E: RequestResponsable>(with endPoint: E) async throws -> R where E.Response == R {
        let urlRequest = try endPoint.makeURLRequest()
        let (data, response) = try await session.data(for: urlRequest)
        try self.checkStatusCode(of: response)
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

    private func checkStatusCode(of response: URLResponse) throws {
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
