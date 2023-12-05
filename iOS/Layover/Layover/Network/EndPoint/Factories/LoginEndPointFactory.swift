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
    func makeAppleLoginEndPoint(with identityToken: String) -> EndPoint<Response<LoginDTO>>
    func makeCheckKakaoIsSignedUp(with socialToken: String) -> EndPoint<Response<CheckSignUpDTO>>
    func makeCheckAppleIsSignedUp(with identityToken: String) -> EndPoint<Response<CheckSignUpDTO>>
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

    func makeAppleLoginEndPoint(with identityToken: String) -> EndPoint<Response<LoginDTO>> {
        var bodyParameters: [String: String] = [String: String]()
        bodyParameters.updateValue(identityToken, forKey: "identityToken")

        return EndPoint(
            path: "/oauth/apple",
            method: .POST,
            bodyParameters: bodyParameters)
    }

    func makeCheckKakaoIsSignedUp(with socialToken: String) -> EndPoint<Response<CheckSignUpDTO>> {
        var bodyParameters = [String: String]()
        bodyParameters.updateValue(socialToken, forKey: "accessToken")

        return EndPoint(
            path: "/oauth/check-signup/kakao",
            method: .POST,
            bodyParameters: bodyParameters
        )
    }

    func makeCheckAppleIsSignedUp(with identityToken: String) -> EndPoint<Response<CheckSignUpDTO>> {
        var bodyParameters = [String: String]()
        bodyParameters.updateValue(identityToken, forKey: "identityToken")

        return EndPoint(
            path: "/oauth/check-signup/apple",
            method: .POST,
            bodyParameters: bodyParameters
        )
    }
}
