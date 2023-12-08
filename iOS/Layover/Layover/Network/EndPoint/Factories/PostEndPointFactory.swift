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
    func makeMapPostListEndPoint(latitude: Double, longitude: Double) -> EndPoint<Response<[PostDTO]>>
    func makeTagSearchPostListEndPoint(by tag: String) -> EndPoint<Response<[PostDTO]>>
}

final class DefaultPostEndPointFactory: PostEndPointFactory {
    func makeHomePostListEndPoint() -> EndPoint<Response<[PostDTO]>> {
        return EndPoint(
            path: "/board/home",
            method: .GET
        )
    }

    func makeMapPostListEndPoint(latitude: Double, longitude: Double) -> EndPoint<Response<[PostDTO]>> {
        var queryParameters = [String: String]()
        queryParameters.updateValue(String(latitude), forKey: "latitude")
        queryParameters.updateValue(String(longitude), forKey: "longitude")

        return EndPoint(
            path: "/board/map",
            method: .GET,
            queryParameters: queryParameters
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
