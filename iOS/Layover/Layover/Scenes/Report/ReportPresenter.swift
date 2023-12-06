//
//  ReportPresenter.swift
//  Layover
//
//  Created by 황지웅 on 12/4/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol ReportPresentationLogic {
    func presentReportPlaybackVideo(with response: ReportModels.ReportPlaybackVideo.Response)
}

final class ReportPresenter: ReportPresentationLogic {

    // MARK: - Properties

    typealias Models = ReportModels
    weak var viewController: ReportDisplayLogic?

    func presentReportPlaybackVideo(with response: ReportModels.ReportPlaybackVideo.Response) {
        let viewModel: Models.ReportPlaybackVideo.ViewModel
        viewModel = Models.ReportPlaybackVideo.ViewModel(reportMessage: response.reportResult ? .success : .fail)
        viewController?.displayReportResult(viewModel: viewModel)
    }
}
