//
//  MapConfigurator.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

final class MapConfigurator: Configurator {
    typealias ViewController = MapViewController

    static let shared = MapConfigurator()

    private init() { }

    func configure(_ viewController: ViewController) {
        let viewController = viewController
        let interactor = MapInteractor()
        let presenter = MapPresenter()
        let router = MapRouter()
        let worker = MapWorker()
        let videoFileWorker = VideoFileWorker()
        let locationManager = CurrentLocationManager()

        router.viewController = viewController
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        interactor.videoFileWorker = videoFileWorker
        interactor.locationManager = locationManager
        presenter.viewController = viewController
        viewController.router = router
        router.dataStore = interactor
    }
}
