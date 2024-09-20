//
//  LoginPresenter.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import UIKit

protocol LoginPresentationLogic {
    func presentPerformLogin()
    func presentSignUp(with response: LoginModels.PerformKakaoLogin.Response)
    func presentSignUp(with response: LoginModels.PerformAppleLogin.Response)
}

final class LoginPresenter {

    // MARK: - Properties

    typealias Models = LoginModels
    weak var viewController: LoginDisplayLogic?

}

// MARK: - Use Case - Login

extension LoginPresenter: LoginPresentationLogic {
    func presentPerformLogin() {
        viewController?.navigateToMain()
    }

    func presentSignUp(with response: LoginModels.PerformKakaoLogin.Response) {
        viewController?.routeToSignUp(with: LoginModels.PerformKakaoLogin.ViewModel())
    }

    func presentSignUp(with response: LoginModels.PerformAppleLogin.Response) {
        viewController?.routeToSignUp(with: LoginModels.PerformAppleLogin.ViewModel())
    }
}
