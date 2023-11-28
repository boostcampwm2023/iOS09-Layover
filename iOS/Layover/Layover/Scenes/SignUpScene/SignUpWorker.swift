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
    func isDuplicate(username: String) async -> Bool
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
    func isDuplicate(username: String) async -> Bool {
        let endPoint = userEndPointFactory.makeCheckUserNameEndPoint(username: username)
        do {
            let responseData = try await provider.request(with: endPoint, authenticationIfNeeded: false)
            guard let data = try await provider.request(with: endPoint, authenticationIfNeeded: false).data else {
                os_log(.error, log: .default, "Failed to check duplicate username with error: %@", responseData.message)
                return false
            }
            return data.exist
        } catch {
            os_log(.error, log: .default, "Failed to check duplicate username with error: %@", error.localizedDescription)
            return false
        }
    }

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
            return true
        } catch {
            os_log(.error, log: .default, "Failed to sign up with error: %@", error.localizedDescription)
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
            return true
        } catch {
            os_log(.error, log: .default, "Failed to sign up with error: %@", error.localizedDescription)
            return false
        }
    }
}
