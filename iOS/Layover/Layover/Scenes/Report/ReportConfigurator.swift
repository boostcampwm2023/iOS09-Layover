//
//  ReportConfigurator.swift
//  Layover
//
//  Created by 황지웅 on 12/4/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

final class ReportConfigurator: Configurator {
    static let shared = ReportConfigurator()

    private init() { }

    func configure(_ viewController: ReportViewController) {
        let viewController: ReportViewController = viewController
        let interactor: ReportInteractor = ReportInteractor()
        let presenter: ReportPresenter = ReportPresenter()
//        let worker: ReportWorker = ReportWorker()
        let worker: ReportWorkerProtocol = MockReportWorker()
        let router: ReportRouter = ReportRouter()

        router.viewController = viewController
        router.dataStore = interactor
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
    }
}
