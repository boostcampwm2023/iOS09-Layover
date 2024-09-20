//
//  EditProfileConfigurator.swift
//  Layover
//
//  Created by kong on 2023/11/27.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

final class EditProfileConfigurator: Configurator {

    typealias ViewController = EditProfileViewController

    static let shared = EditProfileConfigurator()

    private init() { }

    func configure(_ viewController: ViewController) {
        let viewController = viewController
        let interactor = EditProfileInteractor()
        let presenter = EditProfilePresenter()
        let worker = UserWorker()
        let router = EditProfileRouter()

        router.viewController = viewController
        router.dataStore = interactor
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.userWorker = worker
        presenter.viewController = viewController
    }

}
