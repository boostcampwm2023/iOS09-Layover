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
    let authManager: AuthManager

    init(provider: ProviderType, authManager: AuthManager = .shared) {
        self.provider = provider
        self.authManager = authManager
    }

    // MARK: - Login Methods

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

    func kakaoLogin() async -> Bool {
        guard let token = await fetchKakaoLoginToken() else {
            os_log(.error, log: .data, "%@", "Failed to fetch kakao login token")
            return false
        }

        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            os_log(.error, log: .data, "%@", "Failed to fetch base url")
            return false
        }

        var bodyParameters = [String: String]()
        bodyParameters.updateValue(token, forKey: "accessToken")

        let endPoint = EndPoint<Response<LoginDTO>>(baseURL: baseURL,
                                                    path: "/api/v1/auth/login",
                                                    method: .POST,
                                                    bodyParameters: bodyParameters)

        do {
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
