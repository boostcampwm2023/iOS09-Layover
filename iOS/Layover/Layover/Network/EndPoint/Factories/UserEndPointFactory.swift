//
//  UserEndPointFactory.swift
//  Layover
//
//  Created by 김인환 on 11/28/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol UserEndPointFactory {
    func makeUserNameIsNotDuplicateEndPoint(of userName: String) -> EndPoint<Response<CheckUserNameDTO>>
    func makeUserNameModifyEndPoint(userName: String) -> EndPoint<Response<NicknameDTO>>
    func makeIntroduceModifyEndPoint(introduce: String) -> EndPoint<Response<IntroduceDTO>>
    func makeUserWithDrawEndPoint() -> EndPoint<Response<NicknameDTO>>
    func makeUserInformationEndPoint(with id: Int?) -> EndPoint<Response<MemberDTO>>
    func makeUserPostsEndPoint(at cursor: Int?, of id: Int?) -> EndPoint<Response<PostsPageDTO>>
    func makeUserProfileImageDefaultEndPoint() -> EndPoint<Response<Data>>
    func makeFetchUserProfilePresignedURL(of fileType: String) -> EndPoint<Response<PresignedURLDTO>>
}

final class DefaultUserEndPointFactory: UserEndPointFactory {
    func makeUserNameIsNotDuplicateEndPoint(of userName: String) -> EndPoint<Response<CheckUserNameDTO>> {
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
            path: "/member",
            method: .DELETE
        )
    }

    func makeUserInformationEndPoint(with id: Int? = nil) -> EndPoint<Response<MemberDTO>> {
        if let id {
            let queryParameters = ["memberId": id]
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

    func makeUserPostsEndPoint(at cursor: Int?, of id: Int? = nil) -> EndPoint<Response<PostsPageDTO>> {
        var queryParameters: PostRequestDTO?
        if let id {
            queryParameters = PostRequestDTO(cursor: cursor,
                                             memberId: String(id))
        } else {
            queryParameters = PostRequestDTO(cursor: cursor,
                                             memberId: nil)
        }

        return EndPoint(
            path: "/board/profile",
            method: .GET,
            queryParameters: queryParameters
        )
    }

    func makeUserProfileImageDefaultEndPoint() -> EndPoint<Response<Data>> {
        return EndPoint(
            path: "/member/profile-image/default",
            method: .POST
        )
    }

    func makeFetchUserProfilePresignedURL(of fileType: String) -> EndPoint<Response<PresignedURLDTO>> {
        var bodyParameters = [String: String]()
        bodyParameters.updateValue(fileType, forKey: "filetype")

        return EndPoint(
            path: "/member/profile-image/presigned-url",
            method: .POST,
            bodyParameters: bodyParameters
        )
    }
}
