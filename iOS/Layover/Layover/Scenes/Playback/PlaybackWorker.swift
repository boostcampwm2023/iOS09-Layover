//
//  PlaybackWorker.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class PlaybackWorker {

    // MARK: - Properties

    typealias Models = PlaybackModels

    // MARK: - Methods

    func makeInfiniteScroll(posts: [Post]) -> [Post] {
        var tempVideos: [Post] = posts
        let tempLastVideo: Post = posts[tempVideos.count-1]
        let tempFirstVideo: Post = posts[1]
        tempVideos.insert(tempLastVideo, at: 0)
        tempVideos.append(tempFirstVideo)
        return tempVideos
    }
}
