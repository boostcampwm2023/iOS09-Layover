//
//  LoginWorker.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

import OSLog

protocol LoginWorkerProtocol {
    func kakaoLogin() async -> Bool
}

final class LoginWorker: LoginWorkerProtocol {

    // MARK: - Properties

    typealias Models = LoginModels

    let provider: ProviderType
    let loginEndPointFactory: LoginEndPointFactory
    let authManager: AuthManager

    init(provider: ProviderType = Provider(), loginEndPointFactory: LoginEndPointFactory = DefaultLoginEndPointsFactory(), authManager: AuthManager = .shared) {
        self.provider = provider
        self.authManager = authManager
        self.loginEndPointFactory = loginEndPointFactory
    }

    // MARK: - Login Methods

    func kakaoLogin() async -> Bool {
        guard let token = await fetchKakaoLoginToken() else {
            os_log(.error, log: .data, "%@", "Failed to fetch kakao login token")
            return false
        }

        // TODO: 회원 가입 여부 확인

        // 로그인 처리
        do {
            let endPoint = loginEndPointFactory.makeKakaoLoginEndPoint(with: token)
            let result = try await provider.request(with: endPoint, authenticationIfNeeded: false, retryCount: 0)
            authManager.accessToken = result.data?.accessToken
            authManager.refreshToken = result.data?.refreshToken
            return true
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return false
        }
    }

    func appleLogin() {

    }
}

extension LoginWorker {
    @MainActor
    private func fetchKakaoLoginToken() async -> String? {
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
}
