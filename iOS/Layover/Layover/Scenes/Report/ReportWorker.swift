//
//  ReportWorker.swift
//  Layover
//
//  Created by 황지웅 on 12/4/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

import OSLog

protocol ReportWorkerProtocol {
    func reportPlaybackVideo(boardId: Int, reportContent: String) async -> Bool
}

final class ReportWorker: ReportWorkerProtocol {

    // MARK: - Properties

    typealias Models = ReportModels

    private let reportEndPointFactory: ReportEndPointFactory
    private let provider: ProviderType

    init(reportEndPointFactory: ReportEndPointFactory = DefaultReportEndPointFactory(), provider: ProviderType = Provider()) {
        self.reportEndPointFactory = reportEndPointFactory
        self.provider = provider
    }

    func reportPlaybackVideo(boardId: Int, reportContent: String) async -> Bool {
        let endPoint = reportEndPointFactory.reportPlaybackVideoEndpoint(boardId: boardId, reportType: reportContent)
        do {
            let responseData = try await provider.request(with: endPoint)
            guard let _ = responseData.data else {
                os_log(.error, log: .data, "Failed to report with error: %@", responseData.message)
                return false
            }
        } catch {
            os_log(.error, log: .data, "Failed to report with error: %@", error.localizedDescription)
            return false
        }
        return true
    }
}
