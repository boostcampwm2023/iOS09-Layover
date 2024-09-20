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

    struct DisplayedPost: Hashable {
        let thumbnailImageURL: URL
        let videoURL: URL
        let title: String
        let tags: [String]
    }

    enum FetchPosts {
        struct Request {
        }

        struct Response {
            let cursor: Int
            let posts: [Post]
        }

        struct ViewModel {
            let displayedPosts: [DisplayedPost]
        }
    }

    enum FetchThumbnailImageData {
        struct Request {
            let imageURL: URL
            let indexPath: IndexPath
        }

        struct Response {
            let imageData: Data
            let indexPath: IndexPath
        }

        struct ViewModel {
            let imageData: Data
            let indexPath: IndexPath
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

    enum ShowTagPlayList {
        struct Request {
            let tag: String
        }

        struct Response {
        }

        struct ViewModel {
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
