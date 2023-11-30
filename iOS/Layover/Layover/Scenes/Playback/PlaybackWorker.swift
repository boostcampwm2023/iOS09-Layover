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

    func makeInfiniteScroll(videos: [Models.PlaybackVideo]) -> [Models.PlaybackVideo] {
        var tempVideos: [Models.PlaybackVideo] = videos
        var tempLastVideo: Models.PlaybackVideo = videos[tempVideos.count-1]
        tempLastVideo.id = UUID()
        var tempFirstVideo: Models.PlaybackVideo = videos[1]
        tempFirstVideo.id = UUID()
        tempVideos.insert(tempLastVideo, at: 0)
        tempVideos.append(tempFirstVideo)
        return tempVideos
    }
}
