//
//  PostDTO.swift
//  Layover
//
//  Created by 김인환 on 11/30/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

struct PostDTO: Decodable {
    let member: MemberDTO
    let board: BoardDTO
    let tag: [String]
}
