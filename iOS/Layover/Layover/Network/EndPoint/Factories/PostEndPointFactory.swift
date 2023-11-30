//
//  PostEndPointFactory.swift
//  Layover
//
//  Created by 김인환 on 11/30/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol PostEndPointFactory {
    func makeHomePostListEndPoint() -> EndPoint<Response<[PostDTO]>>
    func makeTagSearchPostListEndPoint(by tag: String) -> EndPoint<Response<[PostDTO]>>
}

final class DefaultPostEndPointFactory: PostEndPointFactory {
    func makeHomePostListEndPoint() -> EndPoint<Response<[PostDTO]>> {
        return EndPoint(
            path: "/board/home",
            method: .GET
        )
    }

    func makeTagSearchPostListEndPoint(by tag: String) -> EndPoint<Response<[PostDTO]>> {
        var queryParameters = [String: String]()
        queryParameters.updateValue(tag, forKey: "tag")

        return EndPoint(
            path: "/board/tag",
            method: .GET,
            queryParameters: queryParameters
        )
    }
}
