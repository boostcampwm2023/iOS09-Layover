//
//  ReportPresenter.swift
//  Layover
//
//  Created by 황지웅 on 12/4/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol ReportPresentationLogic {
}

final class ReportPresenter: ReportPresentationLogic {

    // MARK: - Properties

    typealias Models = ReportModels
    weak var viewController: ReportDisplayLogic?

}
