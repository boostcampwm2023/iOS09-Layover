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
    let encodedVideoURL: String
    let videoThumbnailURL: String
    let latitude, longitude, title, content: String

    enum CodingKeys: String, CodingKey {
        case id
        case encodedVideoURL = "encoded_video_url"
        case videoThumbnailURL = "video_thumbnail_url"
        case latitude, longitude, title, content
    }
}

extension BoardDTO {
    func toDomain() -> Board {
        return Board(
            identifier: id,
            title: title,
            description: content,
            thumbnailImageURL: URL(string: videoThumbnailURL),
            videoURL: URL(string: encodedVideoURL),
            latitude: Double(latitude),
            longitude: Double(longitude)
        )
    }
}
