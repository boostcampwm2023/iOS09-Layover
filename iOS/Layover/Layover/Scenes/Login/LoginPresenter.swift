//
//  LoginPresenter.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import UIKit

protocol LoginPresentationLogic {
    func presentPerformKakaoLogin(with response: LoginModels.PerformKakaoLogin.Response)
    func presentPerformAppleLogin(with response: LoginModels.PerformAppleLogin.Response)
}

final class LoginPresenter {

    // MARK: - Properties

    typealias Models = LoginModels
    weak var viewController: LoginDisplayLogic?

}

// MARK: - Use Case - Login

extension LoginPresenter: LoginPresentationLogic {
    func presentPerformKakaoLogin(with response: LoginModels.PerformKakaoLogin.Response) {
        // TODO: Logic 작성

    }
    
    func presentPerformAppleLogin(with response: LoginModels.PerformAppleLogin.Response) {
        // TODO: Logic 작성
    }

}
