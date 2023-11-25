//
//  LoginConfigurator.swift
//  Layover
//
//  Created by 황지웅 on 11/20/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

final class LoginConfigurator: Configurator {
    typealias ViewController = LoginViewController

    static let shared = LoginConfigurator()

    private init() { }

    func configure(_ viewController: LoginViewController) {
        let viewController = viewController
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        let worker = LoginWorker()
        let router = LoginRouter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
    }
}
