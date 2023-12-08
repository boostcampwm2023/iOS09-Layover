//
//  ThumbnailLoadedPost.swift
//  Layover
//
//  Created by kong on 2023/12/09.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

struct ThumbnailLoadedPost {
    let member: Member
    let board: Board
    let tags: [String]
    let thumbnailImageData: Data
}
