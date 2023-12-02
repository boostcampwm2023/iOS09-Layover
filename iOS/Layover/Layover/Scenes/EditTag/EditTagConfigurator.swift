//
//  EditTagConfigurator.swift
//  Layover
//
//  Created by kong on 2023/12/03.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

final class EditTagConfigurator: Configurator {

    typealias ViewController = EditTagViewController

    static let shared = EditTagConfigurator()

    private init() { }

    func configure(_ viewController: ViewController) {
        let viewController = viewController
        let interactor = EditTagInteractor()
        let presenter = EditTagPresenter()
        let router = EditTagRouter()

        router.viewController = viewController
        router.dataStore = interactor
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

}
