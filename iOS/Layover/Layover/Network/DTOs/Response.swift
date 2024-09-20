//
//  Response.swift
//  Layover
//
//  Created by 김인환 on 11/23/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

struct Response<Data: Decodable>: Decodable {
    let statusCode: Int
    let message: String
    let data: Data?
}

struct EmptyData: Decodable { }
