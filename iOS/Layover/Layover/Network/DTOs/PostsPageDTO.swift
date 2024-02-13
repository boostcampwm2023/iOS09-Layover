//
//  PostsPageDTO.swift
//  Layover
//
//  Created by kong on 2024/02/04.
//  Copyright © 2024 CodeBomber. All rights reserved.
//

import Foundation

struct PostsPageDTO: Decodable {
    let lastID: Int
    let posts: [PostDTO]

    enum CodingKeys: String, CodingKey {
        case lastID = "lastId"
        case posts = "boardsResDto"
    }
}

struct PostRequestDTO: Encodable {
    let cursor: Int?
    let memberId: String?
}

extension PostsPageDTO {
    func toDomain() -> PostsPage {
        return PostsPage(
            cursor: lastID,
            posts: posts.map { $0.toDomain() }
        )
    }
}
