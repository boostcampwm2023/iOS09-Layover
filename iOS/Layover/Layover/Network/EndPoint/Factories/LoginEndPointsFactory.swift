//
//  LoginEndPointsFactory.swift
//  Layover
//
//  Created by 김인환 on 11/26/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol LoginEndPointFactory {
    func makeKakaoLoginEndPoint(with socialToken: String) -> EndPoint<Response<LoginDTO>>
    func makeKakaoSignUpEndPoint(socialToken: String, username: String) -> EndPoint<Response<LoginDTO>>
}

struct DefaultLoginEndPointsFactory: LoginEndPointFactory {
    func makeKakaoLoginEndPoint(with socialToken: String) -> EndPoint<Response<LoginDTO>> {
        var bodyParameters = [String: String]()
        bodyParameters.updateValue(socialToken, forKey: "accessToken")

        return EndPoint(
            path: "/oauth/kakao",
            method: .POST,
            bodyParameters: bodyParameters
        )
    }

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
