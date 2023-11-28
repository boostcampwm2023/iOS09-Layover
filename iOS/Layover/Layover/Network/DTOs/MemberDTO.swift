//
//  MemberDTO.swift
//  Layover
//
//  Created by 황지웅 on 11/28/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

struct MemberDTO: Codable, Hashable {
    let username: String
    let introduce: String
    let profileImageURL: URL

    enum CodingKeys: String, CodingKey {
        case username, introduce
        case profileImageURL = "profile_Image_url"
    }
}
