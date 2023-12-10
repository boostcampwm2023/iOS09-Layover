//
//  MapWorker.swift
//  Layover
//
//  Created by kong on 2023/12/06.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

import OSLog

protocol MapWorkerProtocol {
    func fetchPosts(latitude: Double, longitude: Double) async -> [Post]?
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

    func fetchPosts(latitude: Double, longitude: Double) async -> [Post]? {
        let endPoint = postEndPointFactory.makeMapPostListEndPoint(latitude: latitude, longitude: longitude)
        do {
            let response = try await provider.request(with: endPoint)
            guard let posts = response.data else { return nil }
            return await withTaskGroup(of: Post.self,
                                       returning: [Post].self) { group in
                for post in posts {
                    group.addTask {
                        let thumbnailImageData = try? await self.provider.request(url: post.board.videoThumbnailURL)
                        var thumbnailLoadedPost = post.toDomain()
                        thumbnailLoadedPost.thumbnailImageData = thumbnailImageData
                        return thumbnailLoadedPost
                    }
                }
                var thumbnailLoadedPosts: [Post] = []
                for await thumbnailLoadedPost in group {
                    thumbnailLoadedPosts.append(thumbnailLoadedPost)
                }
                return thumbnailLoadedPosts
            }
        } catch {
            os_log(.error, log: .data, "Failed to fetch posts: %@", error.localizedDescription)
            return nil
        }
    }

}
