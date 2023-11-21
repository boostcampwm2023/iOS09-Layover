//
//  LoginResponseExceptionDTO.swift
//  Layover
//
//  Created by 황지웅 on 11/21/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

struct LoginResponseExceptionDTO: Decodable {
    let customCode: String?
    let message: String?
    let statusCode: Int?
    let data: MemberHashDTO?
}
