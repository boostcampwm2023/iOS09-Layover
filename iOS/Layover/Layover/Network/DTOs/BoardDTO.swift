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
    let latitude, longitude: Double
    let title, content: String
    let status: BoardStatus

    enum BoardStatus: String, Decodable {
        case running
        case waiting
        case failure
        case complete
        case deleted
        case inactive

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)

            if let value = BoardStatus(rawValue: rawValue.lowercased()) {
                self = value
            } else {
                self = .inactive
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case encodedVideoURL = "encoded_video_url"
        case videoThumbnailURL = "video_thumbnail_url"
        case latitude, longitude, title, content
        case status
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
            latitude: latitude,
            longitude: longitude
        )
    }
}
