//
//  MapModels.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

enum MapModels {

    struct Post {
        let member: Member
        let board: Board
        let tag: [String]
        let thumnailImageData: Data
    }

    struct DisplayedPost: Hashable {
        let boardID: Int
        let thumbnailImageData: Data
        let videoURL: URL
        let latitude: Double
        let longitude: Double
    }

    // MARK: - Fetch Video Use Cases
    enum FetchVideo {
        struct Request {
            var latitude: Double
            var longitude: Double
        }

        struct Response {
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

    enum FetchPosts {
        struct Request {
            var latitude: Double
            var longitude: Double
        }

        struct Response {
            var posts: [Post]
        }

        struct ViewModel {
            var displayedPosts: [DisplayedPost]

//            struct VideoDataSource: Hashable {
//                var id = UUID()
//                var videoURL: URL
//            }
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

    enum PlayPosts {
        struct Request {
            let selectedIndex: Int
        }

        struct Response {
        }

        struct ViewModel {
        }
    }

    enum SelectVideo {
        struct Request {
            let videoURL: URL
        }

        struct Response {

        }

        struct ViewModel {

        }
    }
}
