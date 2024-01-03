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
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
//        let homeWorker = HomeWorker()
        let homeWorker = MockHomeWorker()
        let videoFileWorker = VideoFileWorker()
        let locationManager = CurrentLocationManager()

        router.viewController = viewController
        router.dataStore = interactor
        presenter.viewController = viewController
        interactor.presenter = presenter
        interactor.homeWorker = homeWorker
        interactor.videoFileWorker = videoFileWorker
        interactor.locationManager = locationManager
        viewController.router = router
        viewController.interactor = interactor

        router.dataStore = interactor
    }
}
