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
    func makeTokenRefreshEndPoint(with refreshToken: String) -> EndPoint<Response<LoginDTO>>
}

struct DefaultLoginEndPointFactory: LoginEndPointFactory {
    func makeKakaoLoginEndPoint(with socialToken: String) -> EndPoint<Response<LoginDTO>> {
        var bodyParameters = [String: String]()
        bodyParameters.updateValue(socialToken, forKey: "accessToken")

        return EndPoint(
            path: "/oauth/kakao",
            method: .POST,
            bodyParameters: bodyParameters
        )
    }

    func makeTokenRefreshEndPoint(with refreshToken: String) -> EndPoint<Response<LoginDTO>> {
        var bodyParameters = [String: String]()
        bodyParameters.updateValue(refreshToken, forKey: "refreshToken")

        return EndPoint(
            path: "/oauth/refresh-token",
            method: .POST,
            bodyParameters: bodyParameters
        )
    }
}