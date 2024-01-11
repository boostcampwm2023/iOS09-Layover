//
//  MockSignUpWorker.swift
//  LayoverTests
//
//  Created by 김인환 on 1/11/24.
//  Copyright © 2024 CodeBomber. All rights reserved.
//

@testable import Layover
import Foundation
import OSLog

class MockSignUpWorker: SignUpWorkerProtocol {

    // MARK: - Properties

    private let provider: ProviderType

    // MARK: - Initializer

    init(provider: ProviderType = Provider(session: .initMockSession(),
                                           authManager: StubAuthManager())) {
        self.provider = provider
    }

    func signUp(withKakao socialToken: String, username: String) async -> Bool {
        guard let mockFileLocation = Bundle(for: type(of: self)).url(forResource: "LoginData", withExtension: "json"),
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
            var bodyParameters = [String: String]()
            bodyParameters.updateValue(socialToken, forKey: "accessToken")
            bodyParameters.updateValue(username, forKey: "username")

            let endPoint = EndPoint<Response<LoginDTO>>(path: "/oauth/signup/kakao",
                                                        method: .POST,
                                                        bodyParameters: bodyParameters)
            let response = try await provider.request(with: endPoint, authenticationIfNeeded: false, retryCount: 0)
            return true
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return false
        }
    }

    func signUp(withApple identityToken: String, username: String) async -> Bool {
        guard let fileLocation: URL = Bundle(for: type(of: self)).url(forResource: "LoginData", withExtension: "json") else {
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
            var bodyParameters: [String: String] = [:]
            bodyParameters.updateValue(identityToken, forKey: "identityToken")
            bodyParameters.updateValue(username, forKey: "username")

            let endPoint = EndPoint<Response<LoginDTO>>(path: "/oauth/signup/apple",
                                                        method: .POST,
                                                        bodyParameters: bodyParameters)
            let response = try await provider.request(with: endPoint, authenticationIfNeeded: false, retryCount: 0)
            return true
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return false
        }
    }
}
