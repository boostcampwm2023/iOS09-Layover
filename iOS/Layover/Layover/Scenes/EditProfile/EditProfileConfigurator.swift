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
        let router = EditProfileRouter()
        router.viewController = viewController

        let presenter = EditProfilePresenter()
        presenter.viewController = viewController

        let interactor = EditProfileInteractor()
        interactor.presenter = presenter

        viewController.router = router
        viewController.interactor = interactor
    }

}
