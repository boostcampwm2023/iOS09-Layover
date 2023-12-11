//
//  ReportDTO.swift
//  Layover
//
//  Created by 황지웅 on 12/5/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

struct ReportDTO: Codable {
    let memberId: Int?
    let boardId: Int
    let reportType: String
}
