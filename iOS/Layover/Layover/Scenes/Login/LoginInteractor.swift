//
//  LoginInteractor.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import UIKit
import AuthenticationServices

import OSLog

protocol LoginBusinessLogic {
    func performKakaoLogin(with request: LoginModels.PerformKakaoLogin.Request) async
    func performAppleLogin(with request: LoginModels.PerformAppleLogin.Request)
}

protocol LoginDataStore {
    var kakaoLoginToken: String? { get set }
    var appleLoginToken: String? { get set }
}

final class LoginInteractor: NSObject, LoginDataStore {

    // MARK: - Properties

    typealias Models = LoginModels

    var worker: LoginWorkerProtocol?
    var presenter: LoginPresentationLogic?

    // MARK: Data Store

    var kakaoLoginToken: String?
    var appleLoginToken: String?
}

// MARK: - Use Case - Login

extension LoginInteractor: LoginBusinessLogic {
    func performKakaoLogin(with request: LoginModels.PerformKakaoLogin.Request) async {
        guard let token = await worker?.fetchKakaoLoginToken() else { return }
        kakaoLoginToken = token
        if await worker?.isRegisteredKakao(with: token) == true,
           await worker?.loginKakao(with: token) == true {
            await MainActor.run {
                presenter?.presentPerformLogin()
            }
        } else {
            await MainActor.run {
                presenter?.presentSignUp(with: Models.PerformKakaoLogin.Response())
            }
        }
    }

    func performAppleLogin(with request: LoginModels.PerformAppleLogin.Request) {
        let appleIDProvider: ASAuthorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
        let loginRequest: ASAuthorizationAppleIDRequest = appleIDProvider.createRequest()
        let authorizationController: ASAuthorizationController = ASAuthorizationController(authorizationRequests: [loginRequest])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension LoginInteractor: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            guard let identityTokenData: Data = appleIDCredential.identityToken,
                  let identityToken: String = String(data: identityTokenData, encoding: .utf8) else {
                return
            }

            appleLoginToken = identityToken

            Task {
                async let isRegistered = await worker?.isRegisteredApple(with: identityToken)
                async let loginResult = await worker?.loginApple(with: identityToken)

                guard await isRegistered == true, await loginResult == true else {
                    await MainActor.run {
                        presenter?.presentSignUp(with: Models.PerformAppleLogin.Response())
                    }
                    return
                }

                presenter?.presentPerformLogin()
            }
        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        os_log(.error, log: .data, "%@", error.localizedDescription)
    }
}
