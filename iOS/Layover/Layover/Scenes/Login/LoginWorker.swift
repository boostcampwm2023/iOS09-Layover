//
//  LoginWorker.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

import OSLog

protocol LoginWorkerProtocol {
    @MainActor func fetchKakaoLoginToken() async -> String?
    func isRegisteredKakao(with socialToken: String) async -> Bool
    func loginKakao(with socialToken: String) async -> Bool
    func isRegisteredApple(with identityToken: String) async -> Bool
    func loginApple(with identityToken: String) async -> Bool
}

final class LoginWorker: NSObject {

    // MARK: - Properties

    typealias Models = LoginModels

    let provider: ProviderType
    let loginEndPointFactory: LoginEndPointFactory
    let authManager: AuthManager

    init(provider: ProviderType = Provider(), loginEndPointFactory: LoginEndPointFactory = DefaultLoginEndPointFactory(), authManager: AuthManager = .shared) {
        self.provider = provider
        self.authManager = authManager
        self.loginEndPointFactory = loginEndPointFactory
    }
}

extension LoginWorker: LoginWorkerProtocol {

    // MARK: - Kakao Login
    @MainActor
    func fetchKakaoLoginToken() async -> String? {
        if UserApi.isKakaoTalkLoginAvailable() {
            return await withCheckedContinuation { continuation in
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    if let error = error {
                        os_log(.error, log: .data, "%@", error.localizedDescription)
                        continuation.resume(returning: nil)
                    } else {
                        continuation.resume(returning: oauthToken?.accessToken)
                    }
                }
            }
        } else {
            return await withCheckedContinuation { continuation in
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    if let error = error {
                        os_log(.error, log: .data, "%@", error.localizedDescription)
                        continuation.resume(returning: nil)
                    } else {
                        continuation.resume(returning: oauthToken?.accessToken)
                    }
                }
            }
        }
    }

    func isRegisteredKakao(with socialToken: String) async -> Bool {
        // TODO: 회원가입 여부 판단. 추후 서버 바뀌면 구현
        return false
//        do {
//            let endPoint = loginEndPointFactory.makeKakaoLoginEndPoint(with: socialToken)
//            let result = try await provider.request(with: endPoint, authenticationIfNeeded: false, retryCount: 0)
//            return true
//        } catch {
//            os_log(.error, log: .data, "%@", error.localizedDescription)
//            return false
//        }
    }

    func loginKakao(with socialToken: String) async -> Bool {
        do {
            let endPoint = loginEndPointFactory.makeKakaoLoginEndPoint(with: socialToken)
            let result = try await provider.request(with: endPoint, authenticationIfNeeded: false, retryCount: 0)

            authManager.accessToken = result.data?.accessToken
            authManager.refreshToken = result.data?.refreshToken
            authManager.isLoggedIn = true
            return true
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return false
        }
    }

    // MARK: - Apple Login

    func isRegisteredApple(with identityToken: String) async -> Bool {
        // TODO: 회원가입 여부 판단
        return false
    }

    func loginApple(with identityToken: String) async -> Bool {
        do {
            let endPoint: EndPoint = loginEndPointFactory.makeAppleLoginEndPoint(with: identityToken)
            let result: EndPoint<Response<LoginDTO>>.Response = try await provider.request(with: endPoint, authenticationIfNeeded: false, retryCount: 0)

            authManager.accessToken = result.data?.accessToken
            authManager.refreshToken = result.data?.refreshToken
            authManager.isLoggedIn = true
            return true
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return false
        }
    }
}
