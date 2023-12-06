//
//  ReportRouter.swift
//  Layover
//
//  Created by 황지웅 on 12/4/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol ReportRoutingLogic {
    func routeToNext()
}

protocol ReportDataPassing {
    var dataStore: ReportDataStore? { get }
}

final class ReportRouter: NSObject, ReportRoutingLogic, ReportDataPassing {

    // MARK: - Properties

    weak var viewController: ReportViewController?
    var dataStore: ReportDataStore?

    // MARK: - Routing

    func routeToNext() {
    }
}
