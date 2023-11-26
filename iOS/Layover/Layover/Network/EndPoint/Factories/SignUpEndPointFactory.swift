//
//  SignUpEndPointsFactory.swift
//  Layover
//
//  Created by 김인환 on 11/27/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol SignUpEndPointFactory {
    func makeKakaoSignUpEndPoint(socialToken: String, username: String) -> EndPoint<Response<LoginDTO>>
}

final class DefaultSignUpEndPointFactory: SignUpEndPointFactory {
    func makeKakaoSignUpEndPoint(socialToken: String, username: String) -> EndPoint<Response<LoginDTO>> {
        var bodyParameters = [String: String]()
        bodyParameters.updateValue(socialToken, forKey: "accessToken")
        bodyParameters.updateValue(username, forKey: "username")

        return EndPoint(
            path: "/oauth/signup/kakao",
            method: .POST,
            bodyParameters: bodyParameters
        )
    }
}
