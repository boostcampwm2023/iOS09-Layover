//
//  PostManagerEndPointFactory.swift
//  Layover
//
//  Created by 황지웅 on 12/5/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol PostManagerEndPointFactory {
    func reportPlaybackVideoEndpoint(boardID: Int, reportType: String) -> EndPoint<Response<ReportDTO>>
    func deletePlaybackVideoEndpoint(boardID: Int) -> EndPoint<Response<EmptyData>>
}

struct DefaultPostManagerEndPointFactory: PostManagerEndPointFactory {
    func reportPlaybackVideoEndpoint(boardID: Int, reportType: String) -> EndPoint<Response<ReportDTO>> {
        let bodyParmeters: ReportDTO = ReportDTO(
            memberId: nil,
            boardID: boardID,
            reportType: reportType)

        return EndPoint(
            path: "/report",
            method: .POST,
            bodyParameters: bodyParmeters)
    }

    func deletePlaybackVideoEndpoint(boardID: Int) -> EndPoint<Response<EmptyData>> {
        let queryParameters = ["boardId": boardID]
        return EndPoint(
            path: "/board",
            method: .DELETE,
            queryParameters: queryParameters
        )
    }
}
