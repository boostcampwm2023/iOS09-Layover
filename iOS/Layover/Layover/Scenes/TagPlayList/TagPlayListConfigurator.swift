//
//  TagPlayListConfigurator.swift
//  Layover
//
//  Created by 김인환 on 11/29/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

final class TagPlayListConfigurator: Configurator {

    static let shared = TagPlayListConfigurator()

    private init() { }

    func configure(_ viewController: TagPlayListViewController) {
        let viewController = viewController
        let interactor = TagPlayListInteractor()
        let presenter = TagPlayListPresenter()
        let worker = MockTagPlayListWorker()
        let router = TagPlayListRouter()

        router.viewController = viewController
        router.dataStore = interactor
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
    }
}
