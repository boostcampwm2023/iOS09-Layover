//
//  UploadPostDTO.swift
//  Layover
//
//  Created by kong on 2023/12/05.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

struct UploadPostDTO: Decodable {
    let id: Int
    let title: String
    let content: String?
    let latitude, longitude: Double
    let tag: [String]
}

struct UploadPostRequestDTO: Encodable {
    let title: String
    let content: String?
    let latitude, longitude: Double
    let tag: [String]
}
