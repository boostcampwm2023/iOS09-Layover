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
        let router = ProfileRouter()
        router.viewController = viewController

        let presenter = ProfilePresenter()
        presenter.viewController = viewController

        let interactor = ProfileInteractor()
        interactor.presenter = presenter

        viewController.router = router
        viewController.interactor = interactor
    }

}
