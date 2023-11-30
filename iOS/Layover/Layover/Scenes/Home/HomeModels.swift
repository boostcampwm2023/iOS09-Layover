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
        let thumbnailURL: URL
        let videoURL: URL
        let title: String
        let tags: [String]
    }

    enum FetchPosts {
        struct Request {
        }

        struct Response {
            let posts: [Post]
        }

        struct ViewModel {
            let posts: [DisplayedPost]
        }
    }

    enum FetchThumbnailImageData {
        struct Request {
            let url: URL
        }

        struct Response {
            let data: Data
        }

        struct ViewModel {
            let data: Data
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
