//
//  MapWorker.swift
//  Layover
//
//  Created by kong on 2023/12/06.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol MapWorkerProtocol {
    func fetchPosts(latitude: Double, longitude: Double) async -> [ThumbnailLoadedPost]?
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

    func fetchPosts(latitude: Double, longitude: Double) async -> [ThumbnailLoadedPost]? {
        let endPoint = postEndPointFactory.makeMapPostListEndPoint(latitude: latitude, longitude: longitude)
        do {
            let response = try await provider.request(with: endPoint)
            guard let data = response.data else { return nil }
            let posts = try await data.concurrentMap { postDTO -> ThumbnailLoadedPost in
                let thumbnailImageData = try await self.provider.request(url: postDTO.board.videoThumbnailURL)
                return .init(member: postDTO.member.toDomain(),
                             board: postDTO.board.toDomain(),
                             tags: postDTO.tag,
                             thumbnailImageData: thumbnailImageData)
            }
            return posts
        } catch {
            return nil
        }
    }

}
