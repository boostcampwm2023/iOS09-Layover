//
//  PlaybackRouter.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol PlaybackRoutingLogic {
    func routeToReport()
}

protocol PlaybackDataPassing {
    var dataStore: PlaybackDataStore? { get }
}

final class PlaybackRouter: NSObject, PlaybackRoutingLogic, PlaybackDataPassing {

    // MARK: - Properties

    weak var viewController: PlaybackViewController?
    var dataStore: PlaybackDataStore?

    // MARK: - Routing

    func routeToReport() {
        let reportViewController: ReportViewController = ReportViewController()
        guard let source = dataStore,
              var destination = reportViewController.router?.dataStore
        else { return }
        destination.boardID = source.prevCell?.boardId
        reportViewController.modalPresentationStyle = .fullScreen
        viewController?.present(reportViewController, animated: false)
    }
}
