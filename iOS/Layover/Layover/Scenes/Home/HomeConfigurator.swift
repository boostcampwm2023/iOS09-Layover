//
//  HomeConfigurator.swift
//  Layover
//
//  Created by 김인환 on 11/16/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class HomeConfigurator: Configurator {

    static let shared = HomeConfigurator()

    private init() { }

    func configure(_ viewController: HomeViewController) {
        let router = HomeRouter()
        router.viewController = viewController

        let presenter = HomePresenter()
        presenter.viewController = viewController

        let interactor = HomeInteractor()
        interactor.presenter = presenter

        viewController.router = router
        viewController.interactor = interactor

        router.dataStore = interactor
    }
}
