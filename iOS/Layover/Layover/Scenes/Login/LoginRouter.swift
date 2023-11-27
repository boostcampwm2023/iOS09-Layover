//
//  LoginRouter.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import UIKit

protocol LoginRoutingLogic {
    func routeToMainTabBar()
    func navigateToKakaoSignUp()
    func navigateToAppleSignUp()
}

protocol LoginDataPassing {
    var dataStore: LoginDataStore? { get }
}

final class LoginRouter: LoginRoutingLogic, LoginDataPassing {

    // MARK: - Properties

    weak var viewController: LoginViewController?
    var dataStore: LoginDataStore?

    // MARK: - Routing

    func routeToMainTabBar() {
        let tabBarViewController = MainTabBarViewController()
        viewController?.navigationController?.setViewControllers([tabBarViewController], animated: true)
    }

    func navigateToKakaoSignUp() {
        let signUpViewController = SignUpViewController()

        guard let source = dataStore,
              var destination = signUpViewController.router?.dataStore
        else { return }

        passKakaoDataToSignUp(source: source, destination: &destination)
        viewController?.navigationController?.pushViewController(signUpViewController, animated: true)
    }

    func navigateToAppleSignUp() {
        // TODO: SignUpRouter로 토큰 값 전달 필요
        let signUpViewController = SignUpViewController()
        viewController?.navigationController?.pushViewController(signUpViewController, animated: true)
    }

    // MARK: - Passing Data

    private func passKakaoDataToSignUp(source: LoginDataStore, destination: inout SignUpDataStore) {
        destination.signUpType = .kakao
        destination.socialToken = source.kakaoLoginToken
    }
}
