//
//  URLSession+.swift
//  Layover
//
//  Created by kong on 2023/11/24.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

extension URLSession {
    static func initMockSession(configuration: URLSessionConfiguration = .ephemeral) -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        return urlSession
    }
}
