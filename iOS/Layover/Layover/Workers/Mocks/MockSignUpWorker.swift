//
//  MockSignUpWorker.swift
//  Layover
//
//  Created by 황지웅 on 11/28/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import OSLog

final class MockSignUpWorker {

    // MARK: - Properties

    private let signUpEndPointFactory: SignUpEndPointFactory
    private let provider: ProviderType
    private let authManager: AuthManager

    // MARK: - Initializer

    init(signUpEndPointFactory: SignUpEndPointFactory = DefaultSignUpEndPointFactory(),
         provider: ProviderType = Provider(session: .initMockSession()),
         authManager: AuthManager = .shared) {
        self.signUpEndPointFactory = signUpEndPointFactory
        self.provider = provider
        self.authManager = authManager
    }
}

// MARK: - SignUpWorkerProtocol

extension MockSignUpWorker: SignUpWorkerProtocol {

    func signUp(withKakao socialToken: String, username: String) async -> Bool {
        guard let mockFileLocation = Bundle.main.url(forResource: "LoginData", withExtension: "json"),
              let mockData = try? Data(contentsOf: mockFileLocation) else {
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
            let endPoint = signUpEndPointFactory.makeKakaoSignUpEndPoint(socialToken: socialToken, username: username)
            let response = try await provider.request(with: endPoint, authenticationIfNeeded: false, retryCount: 0)
            return true
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return false
        }
    }

    func signUp(withApple identityToken: String, username: String) async -> Bool {
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
            let endPoint: EndPoint = signUpEndPointFactory.makeAppleSignUpEndPoint(identityToken: identityToken, username: username)
            let response = try await provider.request(with: endPoint, authenticationIfNeeded: false, retryCount: 0)
            return true
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return false
        }
    }

}
