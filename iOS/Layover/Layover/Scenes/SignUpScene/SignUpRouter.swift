//
//  SignUpRouter.swift
//  Layover
//
//  Created by 김인환 on 11/26/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol SignUpRoutingLogic {
    func routeToBack()
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

    func routeToBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    func navigateToMain() {
        let mainTabBarViewController = MainTabBarViewController()
        viewController?.navigationController?.setNavigationBarHidden(true, animated: false)
        viewController?.navigationController?.setViewControllers([mainTabBarViewController], animated: true)
    }
}
