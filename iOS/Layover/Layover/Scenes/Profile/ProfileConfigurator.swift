//
//  ProfileConfigurator.swift
//  Layover
//
//  Created by kong on 2023/11/21.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

final class ProfileConfigurator: Configurator {

    typealias ViewController = ProfileViewController

    static let shared = ProfileConfigurator()

    private init() { }

    func configure(_ viewController: ViewController) {
        let viewController = viewController
        let interactor = ProfileInteractor()
//        let worker = MockUserWorker()
        let worker = UserWorker()
        let presenter = ProfilePresenter()
        let router = ProfileRouter()

        router.viewController = viewController
        router.dataStore = interactor
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.userWorker = worker
        presenter.viewController = viewController
    }

}
