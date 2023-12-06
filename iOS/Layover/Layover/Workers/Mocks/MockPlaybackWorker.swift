//
//  MockPlaybackWorker.swift
//  Layover
//
//  Created by 황지웅 on 12/7/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import OSLog

final class MockPlaybackWorker: PlaybackWorkerProtocol {

    // MARK: - Properties

    typealias Models = PlaybackModels

    private let provider: ProviderType
    private let deleteendPointFactory: DeleteReportEndFactory

    // MARK: - Methods

    init(provider: ProviderType = Provider(session: .initMockSession()), deleteendPointFactory: DeleteReportEndFactory = DefaultDeleteReportEndPointFactory()) {
        self.provider = provider
        self.deleteendPointFactory = deleteendPointFactory
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
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)
            return (response, nil, nil)
        }

        do {
            let endPoint = EndPoint<Response<EmptyData>>(
                path: "/board",
                method: .DELETE,
                queryParameters: ["boardId": boardID])
            let result = try await provider.request(with: endPoint)
            return true
        } catch {
            os_log(.error, log: .data, "Failed to delete with error%@", error.localizedDescription)
            return false
        }
    }
}
