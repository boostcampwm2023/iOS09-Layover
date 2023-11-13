//
//  NetworkError.swift
//  Layover
//
//  Created by kong on 2023/11/13.
//

import Foundation

enum NetworkError: LocalizedError {
    case unknown
    case components
    case urlRequest
    case server(ServerError)
    case emptyData
    case parsing
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .unknown: "Unknown Error"
        case .components: "URL Components Error"
        case .urlRequest: "URL Request Error"
        case .server(let serverError): "Server Error: \(serverError)"
        case .emptyData: "Empty Data Error"
        case .parsing: "Error While Parsing"
        case .decoding(let error): "Error While Decoding: \(error)"
        }
    }
}

enum ServerError: Int {
    case unknown
    case badReqeust = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
}
