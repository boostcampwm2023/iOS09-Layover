//
//  MockReportWorker.swift
//  Layover
//
//  Created by 황지웅 on 12/5/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import OSLog

final class MockReportWorker: ReportWorkerProtocol {

    // MARK: - Properties

    private let provider: ProviderType = Provider(session: .initMockSession(), authManager: StubAuthManager())

    // MARK: - Methods

    func reportPlaybackVideo(boardId: Int, reportContent: String) async -> Bool {
        guard let mockFileLocation = Bundle.main.url(forResource: "ReportPlaybackVideo", withExtension: "json"),
              let mockData = try? Data(contentsOf: mockFileLocation)
        else {
            os_log(.error, log: .data, "Failed to generate mock with error: %@", "Generate File Error")
            return false
        }
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response, mockData, nil)
        }

        do {
            let bodyParameters = ReportDTO(
                memberId: nil,
                boardId: 1, 
                reportType: "청소년에게 유해한 내용입니다.")
            let endPoint = EndPoint<Response<ReportDTO>>(path: "/report",
                                                         method: .POST,
                                                         bodyParameters: bodyParameters)
            let response = try await provider.request(with: endPoint)
            return true
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return false
        }
    }
}
