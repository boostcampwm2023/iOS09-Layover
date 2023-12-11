//
//  ReportDTO.swift
//  Layover
//
//  Created by 황지웅 on 12/5/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

struct ReportDTO: Codable {
    let memberID: Int?
    let boardID: Int
    let reportType: String

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case boardID = "boardId"
        case reportType
    }
}
