//
//  SignUpConfigurator.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

final class SignUpConfigurator: Configurator {
    static let shared = SignUpConfigurator()

    private init() { }

    func configure(_ viewController: SignUpViewController) {
        let viewController = viewController
        let interactor = SignUpInteractor()
        let userWorker = UserWorker()
        let signUpWorker = SignUpWorker()
        let presenter = SignUpPresenter()
        let router = SignUpRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.userWorker = userWorker
        interactor.signUpWorker = signUpWorker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
