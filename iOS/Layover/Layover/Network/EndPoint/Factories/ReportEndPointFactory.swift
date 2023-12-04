//
//  ReportEndPointFactory.swift
//  Layover
//
//  Created by 황지웅 on 12/5/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol ReportEndPointFactory {
    func reportPlaybackVideoEndpoint(boardId: Int, reportType: String) -> EndPoint<Response<ReportDTO>>
}

struct DefaultReportEndPointFactory: ReportEndPointFactory {    
    func reportPlaybackVideoEndpoint(boardId: Int, reportType: String) -> EndPoint<Response<ReportDTO>> {
        var bodyParmeters: ReportDTO = ReportDTO(
            memberId: nil,
            boardId: boardId,
            reportType: reportType)
        
        return EndPoint(
            path: "/report",
            method: .POST,
            bodyParameters: bodyParmeters)
    }
}
