//
//  LoginInteractor.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import UIKit

protocol LoginBusinessLogic {
    func performKakaoLogin(with request: LoginModels.PerformKakaoLogin.Request)
    func performAppleLogin(with request: LoginModels.PerformAppleLogin.Request)
}

protocol LoginDataStore {
    var kakaoLoginToken: String? { get set }
    var appleLoginToken: String? { get set }
}

final class LoginInteractor: LoginDataStore {

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
    func performKakaoLogin(with request: LoginModels.PerformKakaoLogin.Request) {
        Task {
            guard let token = await worker?.fetchKakaoLoginToken() else { return }
            kakaoLoginToken = token
            if await worker?.isRegisteredKakao(with: token) == true {
                presenter?.presentPerformKakaoLogin(with: .init())
            } else {
                presenter?.presentSignUp(with: Models.PerformKakaoLogin.Response())
            }
        }
    }

    func performAppleLogin(with request: LoginModels.PerformAppleLogin.Request) {
        // TODO: Logic 작성
    }

}
