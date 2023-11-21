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

protocol LoginDataStore { }

final class LoginInteractor {

    // MARK: - Properties

    typealias Models = LoginModels

    var appleLoginWorker: AppleLoginWorker?
    var presenter: LoginPresentationLogic?

}

// MARK: - Use Case - Login

extension LoginInteractor: LoginBusinessLogic {
    func performKakaoLogin(with request: LoginModels.PerformKakaoLogin.Request) {
        // TODO: Logic 작성
    }

    func performAppleLogin(with request: LoginModels.PerformAppleLogin.Request) {
        appleLoginWorker = AppleLoginWorker(window: request.window)
        appleLoginWorker?.appleLogin()
    }

}

extension LoginInteractor: LoginDataStore {

}
