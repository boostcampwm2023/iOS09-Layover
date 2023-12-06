//
//  SettingConfigurator.swift
//  Layover
//
//  Created by 김인환 on 12/6/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

final class SettingConfigurator: Configurator {

    // MARK: - Properties

    static let shared = SettingConfigurator()

    // MARK: - Intializer

    private init() { }

    // MARK: - Methods

    func configure(_ viewController: SettingViewController) {
        let interactor = SettingInteractor()
        let presenter = SettingPresenter()
        let router = SettingRouter()
        let worker = SettingWorker()

        viewController.router = router
        viewController.interactor = interactor
        interactor.worker = worker
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
