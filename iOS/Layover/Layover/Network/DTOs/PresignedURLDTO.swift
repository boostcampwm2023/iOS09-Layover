//
//  PresignedURLDTO.swift
//  Layover
//
//  Created by 김인환 on 12/7/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

struct PresignedURLDTO: Decodable {
    let preSignedURL: String

    enum CodingKeys: String, CodingKey {
        case preSignedURL = "preSignedUrl"
    }
}
