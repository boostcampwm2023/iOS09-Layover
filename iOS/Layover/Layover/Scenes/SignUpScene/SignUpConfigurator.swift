//
//  SignUpConfigurator.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

final class SignUpConfigurator: Configurator {
    typealias ViewController = SignUpViewController

    static let shared = SignUpConfigurator()

    private init() { }

    func configure(_ viewController: ViewController) {
        let viewController = viewController
        let interactor = SignUpInteractor()
        let userWorker = MockUserWorker()
        let presenter = SignUpPresenter()
        let router = SignUpRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.userWorker = userWorker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
