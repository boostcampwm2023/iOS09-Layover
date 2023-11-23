//
//  LoginDTO.swift
//  Layover
//
//  Created by 김인환 on 11/23/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

struct ResponseDTO<Data: Decodable>: Decodable {
    let customCode: String
    let statusCode: Int
    let message: String
    let data: Data?
}
