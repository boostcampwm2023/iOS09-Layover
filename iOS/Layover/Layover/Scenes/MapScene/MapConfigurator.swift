//
//  MapConfigurator.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

final class MapConfigurator: Configurator {
    typealias T = MapViewController

    static let shared = MapConfigurator()

    private init() { }

    func configure(_ viewController: MapViewController) {
        let viewController = viewController
        let interactor = MapInteractor()
        let presenter = MapPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
}
