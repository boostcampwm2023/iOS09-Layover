//
//  EditVideoConfigurator.swift
//  Layover
//
//  Created by kong on 2023/11/29.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

final class EditVideoConfigurator: Configurator {

    typealias ViewController = EditVideoViewController

    static let shared = EditVideoConfigurator()

    private init() { }

    func configure(_ viewController: ViewController) {
        let viewController = viewController
        let videoFileWorker = VideoFileWorker()
        let interactor = EditVideoInteractor()
        let presenter = EditVideoPresenter()
        let router = EditVideoRouter()

        router.viewController = viewController
        router.dataStore = interactor
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.videoFileWorker = videoFileWorker
        presenter.viewController = viewController
    }

}
