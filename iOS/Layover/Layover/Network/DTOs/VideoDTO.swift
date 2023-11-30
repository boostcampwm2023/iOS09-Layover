//
//  VideoDTO.swift
//  Layover
//
//  Created by 황지웅 on 11/28/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

struct VideoDTO: Codable {
    let title: String
    let content: String
    let location: String
    let tags: [String]
    // TODO: 프로필 완성되면 변경
    let member: MemberDTO
    let sdURL: URL
    let hdURL: URL

    enum CodingKeys: String, CodingKey {
        case title, content, location, tags, member
        case sdURL = "sd_url"
        case hdURL = "hd_url"
    }
}
