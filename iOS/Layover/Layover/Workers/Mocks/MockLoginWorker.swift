//
//  MockLoginWorker.swift
//  Layover
//
//  Created by 황지웅 on 11/27/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import OSLog

final class MockLoginWorker: LoginWorkerProtocol {

    // MARK: - Properties

    private let provider: ProviderType
    private let loginEndPointFactory: LoginEndPointFactory
    private let authManager: AuthManager

    init(provider: ProviderType = Provider(session: .initMockSession()),
         loginEndPointFactory: LoginEndPointFactory = DefaultLoginEndPointFactory(),
         authManager: AuthManager = .shared) {
        self.provider = provider
        self.authManager = authManager
        self.loginEndPointFactory = loginEndPointFactory
    }

    private let headers: [String: String] = ["Content-Type": "application/json", "Authorization": "mock token"]

    // MARK: - Methods

    func fetchKakaoLoginToken() async -> String? {
        return "mock token"
    }

    func isRegisteredKakao(with socialToken: String) async -> Bool {
        return false
    }

    func loginKakao(with socialToken: String) async -> Bool {
        return true
    }

    func isRegisteredApple(with identityToken: String) async -> Bool {
        // TODO: 로직 구현
        return false
    }

    func loginApple(with identityToken: String) async -> Bool {
        guard let fileLocation: URL = Bundle.main.url(forResource: "LoginData", withExtension: "json") else {
            return false
        }
        guard let mockData: Data = try? Data(contentsOf: fileLocation) else {
            return false
        }
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response, mockData, nil)
        }
        do {
            let endPoint: EndPoint = loginEndPointFactory.makeAppleLoginEndPoint(with: identityToken)
            let response = try await provider.request(with: endPoint, authenticationIfNeeded: false, retryCount: 0)
            return true
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return false
        }
    }
}
