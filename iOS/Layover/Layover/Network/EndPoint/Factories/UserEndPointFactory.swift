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
    func makeUserNameModifyEndPoint(userName: String) -> EndPoint<Response<NicknameDTO>>
    func makeIntroduceModifyEndPoint(introduce: String) -> EndPoint<Response<IntroduceDTO>>
    func makeUserWithDrawEndPoint() -> EndPoint<Response<NicknameDTO>>
    func makeUserInformationEndPoint(with id: Int?) -> EndPoint<Response<MemberDTO>>
    func makeUserPostsEndPoint(at page: Int, of id: Int?) -> EndPoint<Response<[PostDTO]>>
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

    func makeUserNameModifyEndPoint(userName: String) -> EndPoint<Response<NicknameDTO>> {
        var bodyParameters = [String: String]()
        bodyParameters.updateValue(userName, forKey: "username")

        return EndPoint(
            path: "/member/username",
            method: .PATCH,
            bodyParameters: bodyParameters
        )
    }

    func makeIntroduceModifyEndPoint(introduce: String) -> EndPoint<Response<IntroduceDTO>> {
        var bodyParameters = [String: String]()
        bodyParameters.updateValue(introduce, forKey: "introduce")

        return EndPoint(
            path: "/member/introduce",
            method: .PATCH,
            bodyParameters: bodyParameters
        )
    }

    func makeUserWithDrawEndPoint() -> EndPoint<Response<NicknameDTO>> {
        return EndPoint(
            path: "/member/withdraw",
            method: .DELETE
        )
    }

    func makeUserInformationEndPoint(with id: Int? = nil) -> EndPoint<Response<MemberDTO>> {
        if let id {
            let queryParameters = ["id": id]
            return EndPoint(
                path: "/member",
                method: .GET,
                queryParameters: queryParameters
            )
        }

        return EndPoint(
            path: "/member",
            method: .GET
        )
    }

    func makeUserPostsEndPoint(at page: Int, of id: Int? = nil) -> EndPoint<Response<[PostDTO]>> {

        var queryParameters = [String: String]()
        queryParameters.updateValue(String(page), forKey: "page")

        if let id {
            queryParameters.updateValue(String(id), forKey: "id")
        }

        return EndPoint(
            path: "/board/profile",
            method: .GET,
            queryParameters: queryParameters
        )
    }
}
