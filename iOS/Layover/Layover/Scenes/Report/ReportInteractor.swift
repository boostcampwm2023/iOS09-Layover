//
//  ReportInteractor.swift
//  Layover
//
//  Created by 황지웅 on 12/4/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol ReportBusinessLogic {
}

protocol ReportDataStore {
}

final class ReportInteractor: ReportBusinessLogic, ReportDataStore {

    // MARK: - Properties

    typealias Models = ReportModels

    lazy var worker = ReportWorker()
    var presenter: ReportPresentationLogic?

}
