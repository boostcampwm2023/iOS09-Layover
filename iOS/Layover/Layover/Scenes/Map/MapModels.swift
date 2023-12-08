//
//  MapModels.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

enum MapModels {

    struct DisplayedPost: Hashable {
        let boardID: Int
        let thumbnailImageData: Data
        let videoURL: URL
        let latitude: Double
        let longitude: Double
    }

    // MARK: - Fetch Video Use Cases

    enum FetchPosts {
        struct Request {
            var latitude: Double
            var longitude: Double
        }

        struct Response {
            var posts: [ThumbnailLoadedPost]
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
}
