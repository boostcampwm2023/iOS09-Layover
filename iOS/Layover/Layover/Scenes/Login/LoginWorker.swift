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
    func isRegisteredKakao(with socialToken: String) async -> Bool?
    func loginKakao(with socialToken: String) async -> Bool
    func isRegisteredApple(with identityToken: String) async -> Bool?
    func loginApple(with identityToken: String) async -> Bool
}

final class LoginWorker: NSObject {

    // MARK: - Properties

    typealias Models = LoginModels

    private let provider: ProviderType
    private let loginEndPointFactory: LoginEndPointFactory
    private let userEndPointFactory: UserEndPointFactory
    private let authManager: AuthManager

    init(provider: ProviderType = Provider(), 
         loginEndPointFactory: LoginEndPointFactory = DefaultLoginEndPointFactory(),
         userEndPointFactory: UserEndPointFactory = DefaultUserEndPointFactory(),
         authManager: AuthManager = .shared) {
        self.provider = provider
        self.authManager = authManager
        self.loginEndPointFactory = loginEndPointFactory
        self.userEndPointFactory = userEndPointFactory
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

    func isRegisteredKakao(with socialToken: String) async -> Bool? {
        do {
            let endPoint = loginEndPointFactory.makeCheckKakaoIsSignedUpEndPoint(with: socialToken)
            let result = try await provider.request(with: endPoint, authenticationIfNeeded: false)
            return result.data?.isAlreadyExist
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return nil
        }
    }

    func loginKakao(with socialToken: String) async -> Bool {
        do {
            let endPoint = loginEndPointFactory.makeKakaoLoginEndPoint(with: socialToken)
            let result = try await provider.request(with: endPoint, authenticationIfNeeded: false)

            authManager.login(accessToken: result.data?.accessToken,
                              refreshToken: result.data?.refreshToken,
                              loginType: .kakao)
            authManager.memberID = await fetchMemberId()
            return true
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return false
        }
    }

    // MARK: - Apple Login

    func isRegisteredApple(with identityToken: String) async -> Bool? {
        do {
            let endPoint = loginEndPointFactory.makeCheckAppleIsSignedUpEndPoint(with: identityToken)
            let result = try await provider.request(with: endPoint, authenticationIfNeeded: false)
            return result.data?.isAlreadyExist
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return nil
        }
    }

    func loginApple(with identityToken: String) async -> Bool {
        do {
            let endPoint: EndPoint = loginEndPointFactory.makeAppleLoginEndPoint(with: identityToken)
            let result: EndPoint<Response<LoginDTO>>.Response = try await provider.request(with: endPoint, authenticationIfNeeded: false)

            authManager.login(accessToken: result.data?.accessToken,
                              refreshToken: result.data?.refreshToken,
                              loginType: .apple)
            authManager.memberID = await fetchMemberId()
            return true
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return false
        }
    }

    private func fetchMemberId() async -> Int? {
        let endPoint = userEndPointFactory.makeUserInformationEndPoint(with: nil)
        do {
            let responseData = try await provider.request(with: endPoint)
            guard let data = responseData.data else {
                os_log(.error, log: .default, "Failed to fetch member id with error: %@", responseData.message)
                return nil
            }
            return data.id
        } catch {
            os_log(.error, log: .default, "Failed to fetch member id with error: %@", error.localizedDescription)
            return nil
        }
    }
}
