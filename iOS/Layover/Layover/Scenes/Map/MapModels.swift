//
//  MapModels.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

enum MapModels {

    static let searchRadiusInMeters: Double = 10000

    struct DisplayedPost: Hashable {
        let boardID: Int
        let thumbnailImageURL: URL?
        let videoURL: URL?
        let latitude: Double
        let longitude: Double
        let boardStatus: BoardStatus
    }

    // MARK: - Fetch Video Use Cases

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
        }
    }

    // MARK: - Move To Playback Scene

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

    enum CheckLocationAuthorizationOnEntry {
        struct ViewModel {
            let latitude: Double = 36.350411
            let longitude: Double = 127.384548
        }
    }
}
