//
//  UploadPost.swift
//  Layover
//
//  Created by kong on 2023/12/05.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

struct UploadPost {
    let title: String
    let content: String?
    let latitude, longitude: Double
    let tag: [String]
    let videoURL: URL
}
