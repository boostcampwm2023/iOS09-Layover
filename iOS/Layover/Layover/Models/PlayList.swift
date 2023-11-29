//
//  PlayList.swift
//  Layover
//
//  Created by 김인환 on 11/29/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

struct PlayList: Equatable {
    var identifier: Int
    var title: String
    var description: String?
    var thumbnailImageURL: URL?
}
