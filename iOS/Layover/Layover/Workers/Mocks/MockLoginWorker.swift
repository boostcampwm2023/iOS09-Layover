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

    init(provider: ProviderType = Provider(session: .initMockSession(),
                                           authManager: StubAuthManager())) {
        self.provider = provider
    }

    // MARK: - Methods

    func fetchKakaoLoginToken() async -> String? {
        return "mock token"
    }

    func isRegisteredKakao(with socialToken: String) async -> Bool {
        return false
    }

    func loginKakao(with socialToken: String) async -> Bool {
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
            var bodyParameters = [String: String]()
            bodyParameters.updateValue(socialToken, forKey: "accessToken")
            let endPoint = EndPoint<Response<LoginDTO>>(path: "/oauth/kakao",
                                                        method: .POST,
                                                        bodyParameters: bodyParameters)
            let response = try await provider.request(with: endPoint, authenticationIfNeeded: false, retryCount: 0)
            return true
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return false
        }
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
            var bodyParameters = [String: String]()
            bodyParameters.updateValue(identityToken, forKey: "identityToken")
            let endPoint = EndPoint<Response<LoginDTO>>(path: "/oauth/apple",
                                                        method: .POST,
                                                        bodyParameters: bodyParameters
            )
            let response = try await provider.request(with: endPoint, authenticationIfNeeded: false, retryCount: 0)
            return true
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return false
        }
    }
}