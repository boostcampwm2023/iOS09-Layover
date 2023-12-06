//
//  PlaybackWorker.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit
import OSLog

protocol DeleteWorkerProtocol {
    func deletePlaybackVideo(boardID: Int) async -> Bool
}

final class PlaybackWorker {

    // MARK: - Properties

    typealias Models = PlaybackModels

    private let provider: ProviderType
    private let deleteEndPointFactory: DeleteReportEndFactory

    // MARK: - Methods

    init(provider: ProviderType = Provider(), deleteEndPointFactory: DeleteReportEndFactory = DefaultDeleteReportEndPointFactory()) {
        self.provider = provider
        self.deleteEndPointFactory = deleteEndPointFactory
    }

    func makeInfiniteScroll(posts: [Post]) -> [Post] {
        var tempVideos: [Post] = posts
        let tempFirstCellIndex: Int = posts.count == 1 ? 1 : 0
        let tempLastVideo: Post = posts[tempFirstCellIndex]
        let tempFirstVideo: Post = posts[1]
        tempVideos.insert(tempLastVideo, at: 0)
        tempVideos.append(tempFirstVideo)
        return tempVideos
    }

    func deletePlaybackVideo(boardID: Int) async -> Bool {
        let endPoint = deleteEndPointFactory.deletePlaybackVideoEndpoint(boardID: boardID)
        do {
            _ = try await provider.request(with: endPoint)
            return true
        } catch {
            os_log(.error, log: .data, "Failed to delete with error: %@", error.localizedDescription)
            return false
        }
    }
}
