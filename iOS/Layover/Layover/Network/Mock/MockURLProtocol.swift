//
//  MockURLProtocol.swift
//  Layover
//
//  Created by kong on 2023/11/24.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    private static var _requestHandler: ((URLRequest) -> (HTTPURLResponse?, Data?, Error?))?
    private static var lock = NSLock()
    static var requestHandler: ((URLRequest) -> (HTTPURLResponse?, Data?, Error?))? {
        get { lock.withLock { _requestHandler }}
        set { lock.withLock { _requestHandler = newValue }}
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else { return }
        let (response, data, error) = handler(request)

        if let error = error {
          client?.urlProtocol(self, didFailWithError: error)
        }

        if let response = response {
          client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let data = data {
          client?.urlProtocol(self, didLoad: data)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }
}

extension NSLocking {
    func locked<T>(_ closure: () -> T) -> T {
        lock()
        defer { unlock() }
        return closure()
    }
}
