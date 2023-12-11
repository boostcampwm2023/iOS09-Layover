//
//  SignUpWorker.swift
//  Layover
//
//  Created by 김인환 on 11/27/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import OSLog

protocol SignUpWorkerProtocol {
    func signUp(withKakao socialToken: String, username: String) async -> Bool
    func signUp(withApple identityToken: String, username: String) async -> Bool
}

final class SignUpWorker {

    // MARK: Properties

    private let signUpEndPointFactory: SignUpEndPointFactory
    private let userEndPointFactory: UserEndPointFactory
    private let provider: ProviderType
    private let authManager: AuthManagerProtocol

    // MARK: Intializer

    init(signUpEndPointFactory: SignUpEndPointFactory = DefaultSignUpEndPointFactory(),
         userEndPointFactory: UserEndPointFactory = DefaultUserEndPointFactory(),
         provider: ProviderType = Provider(),
         authManager: AuthManagerProtocol = AuthManager.shared) {
        self.signUpEndPointFactory = signUpEndPointFactory
        self.userEndPointFactory = userEndPointFactory
        self.provider = provider
        self.authManager = authManager
    }
}

// MARK: - SignUpWorkerProtocol

extension SignUpWorker: SignUpWorkerProtocol {

    func signUp(withKakao socialToken: String, username: String) async -> Bool {
        let endPoint = signUpEndPointFactory.makeKakaoSignUpEndPoint(socialToken: socialToken, username: username)
        do {
            let responseData = try await provider.request(with: endPoint, authenticationIfNeeded: false)

            guard let data = responseData.data else {
                os_log(.error, log: .default, "Failed to sign up with error: %@", responseData.message)
                return false
            }

            authManager.accessToken = data.accessToken
            authManager.refreshToken = data.refreshToken
            authManager.isLoggedIn = true
            authManager.loginType = .kakao
            authManager.memberID = await fetchMemberId()
            return true
        } catch {
            os_log(.error, log: .data, "Failed to sign up with error: %@", error.localizedDescription)
            return false
        }
    }

    func signUp(withApple identityToken: String, username: String) async -> Bool {
        let endPoint = signUpEndPointFactory.makeAppleSignUpEndPoint(identityToken: identityToken, username: username)
        do {
            let responseData = try await provider.request(with: endPoint, authenticationIfNeeded: false)

            guard let data = responseData.data else {
                os_log(.error, log: .default, "Failed to sign up with error: %@", responseData.message)
                return false
            }
            authManager.accessToken = data.accessToken
            authManager.refreshToken = data.refreshToken
            authManager.isLoggedIn = true
            authManager.loginType = .apple
            authManager.memberID = await fetchMemberId()
            return true
        } catch {
            os_log(.error, log: .data, "Failed to sign up with error: %@", error.localizedDescription)
            return false
        }
    }

    private func fetchMemberId() async -> Int? {
        let endPoint = userEndPointFactory.makeUserInformationEndPoint(with: nil)
        do {
            let responseData = try await provider.request(with: endPoint)
            guard let data = responseData.data else {
                os_log(.error, log: .data, "Failed to fetch member id with error: %@", responseData.message)
                return nil
            }
            return data.id
        } catch {
            os_log(.error, log: .data, "Failed to fetch member id with error: %@", error.localizedDescription)
            return nil
        }
    }
}
