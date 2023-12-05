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
        if response.reportResult {
            viewModel = Models.ReportPlaybackVideo.ViewModel(reportMessage: "신고가 접수되었습니다.")
        } else {
            viewModel = Models.ReportPlaybackVideo.ViewModel(reportMessage: "신고 접수에 실패했습니다. 다시 시도해주세요.")
        }
        viewController?.displayReportResult(viewModel: viewModel)
    }
}
