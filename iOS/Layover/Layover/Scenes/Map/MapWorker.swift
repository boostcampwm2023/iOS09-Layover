//
//  MapWorker.swift
//  Layover
//
//  Created by kong on 2023/12/06.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol MapWorkerProtocol {
    func fetchPosts(latitude: Double, longitude: Double) async -> [MapModels.Post]?
}

final class MapWorker: MapWorkerProtocol {

    // MARK: - Properties

    typealias Models = MapModels
    private let provider: ProviderType
    private let postEndPointFactory: PostEndPointFactory

    // MARK: - Methods

    init(provider: ProviderType = Provider(),
         postEndPointFactory: PostEndPointFactory = DefaultPostEndPointFactory()) {
        self.provider = provider
        self.postEndPointFactory = postEndPointFactory
    }

    func fetchPosts(latitude: Double, longitude: Double) async -> [Models.Post]? {
        let endPoint = postEndPointFactory.makeMapPostListEndPoint(latitude: latitude, longitude: longitude)
        do {
            let response = try await provider.request(with: endPoint)
            guard var data = response.data else { return nil }

            let posts = try await data.asyncMap { postDTO -> Models.Post in
                let thumnailImageData = try await provider.request(url: postDTO.board.videoThumbnailURL)
                return .init(member: postDTO.member.toDomain(),
                             board: postDTO.board.toDomain(),
                             tag: postDTO.tag,
                             thumnailImageData: thumnailImageData)
            }
            return posts
        } catch {
            return nil
        }
    }

}
