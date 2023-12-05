//
//  UploadPostConfigurator.swift
//  Layover
//
//  Created by kong on 2023/12/03.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

final class UploadPostConfigurator: Configurator {

    typealias ViewController = UploadPostViewController

    static let shared = UploadPostConfigurator()

    private init() { }

    func configure(_ viewController: ViewController) {
        let viewController = viewController
        let interactor = UploadPostInteractor()
        let presenter = UploadPostPresenter()
        let router = UploadPostRouter()
        let worker = UploadPostWorker()

        worker.sessionTaskDelegate = interactor
        router.viewController = viewController
        router.dataStore = interactor
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
    }

}
