//
//  Requestable.swift
//  Layover
//
//  Created by kong on 2023/11/13.
//

import Foundation

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: Encodable? { get }
    var bodyParameters: Encodable? { get }
    var headers: [String: String]? { get }
}

extension Requestable {
    func makeURLRequest() throws -> URLRequest {
        let url = try makeURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        if let bodyParameters = try bodyParameters?.toJSONObject() {
            if !bodyParameters.isEmpty {
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters)
            }
        }

        headers?.forEach({ key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        })

        return urlRequest
    }

    func makeURL() throws -> URL {
        let fullPath = baseURL + path
        guard var urlComponents = URLComponents(string: fullPath) else { throw NetworkError.components }
        var urlQueryItems = [URLQueryItem]()

        if let queryParameters = try queryParameters?.toJSONObject() {
            queryParameters.forEach { key, value in
                urlQueryItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
        }

        urlComponents.queryItems = urlQueryItems.isEmpty ? nil : urlQueryItems

        guard let url = urlComponents.url else { throw NetworkError.components }

        return url
    }
}

extension Encodable {
    func toJSONObject() throws -> [String: Any]? {
        if let data = self as? Data { return try JSONSerialization.jsonObject(with: data) as? [String: Any] }
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String: Any]
    }
}
