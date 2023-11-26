//
//  SignUpRouter.swift
//  Layover
//
//  Created by 김인환 on 11/26/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol SignUpRoutingLogic {
    func navigateToMain()
}

protocol SignUpDataPassing {
    var dataStore: SignUpDataStore? { get set }
}

final class SignUpRouter: SignUpRoutingLogic, SignUpDataPassing {

    // MARK: - Properties

    typealias Models = SignUpModels
    weak var viewController: SignUpViewController?
    var dataStore: SignUpDataStore?

    // MARK: - Routing

    func navigateToMain() {
        let mainTabBarViewController = MainTabBarViewController()
        viewController?.navigationController?.setViewControllers([mainTabBarViewController], animated: true)
    }
}
