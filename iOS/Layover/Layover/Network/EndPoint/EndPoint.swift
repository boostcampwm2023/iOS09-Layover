//
//  EndPoint.swift
//  Layover
//
//  Created by kong on 2023/11/13.
//

import Foundation

protocol RequestResponsable: Requestable, Responsable { }

final class EndPoint<R>: RequestResponsable {
    typealias Response = R

    var baseURL: String
    var path: String
    var method: HTTPMethod
    var queryParameters: Encodable?
    var bodyParameters: Encodable?
    var headers: [String: String]?

    init(baseURL: String = Bundle.main.infoDictionary?["BASE_URL"] as? String ?? "",
         path: String,
         method: HTTPMethod,
         queryParameters: Encodable? = nil,
         bodyParameters: Encodable? = nil,
         headers: [String: String]? = ["Content-Type": "application/json"]) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.headers = headers
    }
}
