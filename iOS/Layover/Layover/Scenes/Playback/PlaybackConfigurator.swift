//
//  PlaybackConfigurator.swift
//  Layover
//
//  Created by 황지웅 on 11/28/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

final class PlaybackConfigurator: Configurator {
    typealias ViewController = PlaybackViewController

    static let shared = PlaybackConfigurator()

    private init() { }

    func configure(_ viewController: PlaybackViewController) {
        let viewController: PlaybackViewController = viewController
        let interactor: PlaybackInteractor = PlaybackInteractor()
        let presenter: PlaybackPresenter = PlaybackPresenter()
        let worker: PlaybackWorkerProtocol = PlaybackWorker()
        let router: PlaybackRouter = PlaybackRouter()

        router.viewController = viewController
        router.dataStore = interactor
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
    }
}
