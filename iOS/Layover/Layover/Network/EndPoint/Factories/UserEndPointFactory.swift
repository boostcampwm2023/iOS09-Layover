//
//  UserEndPointFactory.swift
//  Layover
//
//  Created by 김인환 on 11/28/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol UserEndPointFactory {
    func makeCheckUserNameEndPoint(of userName: String) -> EndPoint<Response<CheckUserNameDTO>>
}

final class DefaultUserEndPointFactory: UserEndPointFactory {
    func makeCheckUserNameEndPoint(of userName: String) -> EndPoint<Response<CheckUserNameDTO>> {
        var bodyParameters = [String: String]()
        bodyParameters.updateValue(userName, forKey: "username")

        return EndPoint(
            path: "/member/check-username",
            method: .POST,
            bodyParameters: bodyParameters
        )
    }
}
