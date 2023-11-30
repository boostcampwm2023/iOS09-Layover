//
//  MapModels.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

enum MapModels {

    // MARK: - Fetch Video Use Cases
    enum FetchVideo {
        struct Request {
            var latitude: Double
            var longitude: Double
        }

        struct Reponse {
            var videoURLs: [URL]
        }

        struct ViewModel {
            var videoDataSources: [VideoDataSource]

            struct VideoDataSource: Hashable {
                var id = UUID()
                var videoURL: URL
            }
        }
    }

    // MARK: - Move To Playback Scene

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
