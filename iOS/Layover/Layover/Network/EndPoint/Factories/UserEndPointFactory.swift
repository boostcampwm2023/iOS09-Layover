//
//  UserEndPointFactory.swift
//  Layover
//
//  Created by 김인환 on 11/28/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol UserEndPointFactory {
    func makeUserNameIsDuplicateEndPoint(of userName: String) -> EndPoint<Response<CheckUserNameDTO>>
    func makeUserNameModifyEndPoint(into userName: String) -> EndPoint<Response<NicknameDTO>>
}

final class DefaultUserEndPointFactory: UserEndPointFactory {
    func makeUserNameIsDuplicateEndPoint(of userName: String) -> EndPoint<Response<CheckUserNameDTO>> {
        var bodyParameters = [String: String]()
        bodyParameters.updateValue(userName, forKey: "username")

        return EndPoint(
            path: "/member/check-username",
            method: .POST,
            bodyParameters: bodyParameters
        )
    }

    func makeUserNameModifyEndPoint(into userName: String) -> EndPoint<Response<NicknameDTO>> {
        var bodyParameters = [String: String]()
        bodyParameters.updateValue(userName, forKey: "username")

        return EndPoint(
            path: "/member/username",
            method: .PATCH,
            bodyParameters: bodyParameters
        )
    }
}
