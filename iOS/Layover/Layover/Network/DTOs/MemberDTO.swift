//
//  MemberDTO.swift
//  Layover
//
//  Created by 김인환 on 11/30/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

struct MemberDTO: Decodable {
    let id: Int
    let username, introduce: String
    let profileImageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, username, introduce
        case profileImageURL = "profile_image_url"
    }
}

extension MemberDTO {
    func toDomain() -> Member {
        var imageURL: URL?
        if let profileImageURL {
            imageURL = URL(string: profileImageURL)
        }
        
        return Member(
            identifier: id,
            username: username,
            introduce: introduce,
            profileImageURL: imageURL
        )
    }
}
