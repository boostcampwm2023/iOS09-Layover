//
//  Board.swift
//  Layover
//
//  Created by 김인환 on 11/30/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

struct Board {
    let identifier: Int
    let title: String
    let description: String?
    let thumbnailImageURL: URL?
    let videoURL: URL?
    let latitude: Double
    let longitude: Double
}
