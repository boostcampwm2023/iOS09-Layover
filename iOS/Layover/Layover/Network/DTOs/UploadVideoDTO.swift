//
//  UploadVideoDTO.swift
//  Layover
//
//  Created by kong on 2023/12/05.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

struct UploadVideoDTO: Decodable {
    let preSignedURL: String

    enum CodingKeys: String, CodingKey {
        case preSignedURL = "preSignedUrl"
    }
}

struct UploadVideoRequestDTO: Encodable {
    let boardID: Int
    let filetype: String

    enum CodingKeys: String, CodingKey {
        case boardID = "boardId"
        case filetype
    }
}
