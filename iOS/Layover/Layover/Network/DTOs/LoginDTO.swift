//
//  LoginDTO.swift
//  Layover
//
//  Created by 김인환 on 11/23/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

struct LoginDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}

struct TestDTO: Decodable {
    let accessToken: String?
    let refreshToken: String?
}
