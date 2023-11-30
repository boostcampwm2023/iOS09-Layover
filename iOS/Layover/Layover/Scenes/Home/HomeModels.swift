//
//  HomeModels.swift
//  Layover
//
//  Created by 김인환 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

enum HomeModels {

    // MARK: - Use Cases

    enum CarouselVideos {
        struct Request {
        }

        struct Response {
            var videoURLs: [URL]
        }

        struct ViewModel {
            var videoURLs: [URL]
        }
    }

    enum MoveToPlaybackScene {
        struct Request {
            let index: Int
            let videos: [Post]
        }

        struct Response {
            let index: Int
            let videos: [Post]
        }

        struct ViewModel {
            let index: Int
            let videos: [Post]
        }
    }
}
