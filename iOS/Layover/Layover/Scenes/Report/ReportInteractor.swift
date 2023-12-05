//
//  ReportInteractor.swift
//  Layover
//
//  Created by 황지웅 on 12/4/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol ReportBusinessLogic {
    @discardableResult
    func reportPlaybackVideo(with request: ReportModels.ReportPlaybackVideo.Request) -> Task<Bool, Never>
}

protocol ReportDataStore {
    var boardID: Int? { get set }
}

final class ReportInteractor: ReportBusinessLogic, ReportDataStore {

    // MARK: - Properties

    typealias Models = ReportModels

    var worker: ReportWorkerProtocol?
    var presenter: ReportPresentationLogic?

    var boardID: Int?

    func reportPlaybackVideo(with request: ReportModels.ReportPlaybackVideo.Request) -> Task<Bool, Never> {
        Task {
            guard let boardID,
                  let worker
            else { return false }
            let result: Bool = await worker.reportPlaybackVideo(boardId: boardID, reportContent: request.reportContent)
            let response: Models.ReportPlaybackVideo.Response = Models.ReportPlaybackVideo.Response(reportResult: result)
            await MainActor.run {
                presenter?.presentReportPlaybackVideo(with: response)
            }
            return true
        }
    }
}
