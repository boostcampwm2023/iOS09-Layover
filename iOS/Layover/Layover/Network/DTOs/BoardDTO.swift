//
//  BoardDTO.swift
//  Layover
//
//  Created by 김인환 on 11/30/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

struct BoardDTO: Decodable {
    let id: Int
    let url: String
    let videoThumbnail: String
    let latitude, longitude, title, content, status: String

    enum CodingKeys: String, CodingKey {
        case id
        case url = "url"
        case videoThumbnail = "video_thumbnail"
        case latitude, longitude, title, content, status
    }
}
