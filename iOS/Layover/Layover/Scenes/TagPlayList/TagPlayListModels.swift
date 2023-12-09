//
//  TagPlayListModels.swift
//  Layover
//
//  Created by 김인환 on 11/29/23.
//  Copyright (c) 2023 CodeBomber. All rights reserved.
//

import UIKit

enum TagPlayListModels {
    // MARK: Use cases

    struct DisplayedPost: Hashable {
        let identifier: Int
        let thumbnailImageData: Data?
        let title: String
    }

    enum FetchPosts {
        struct Request {
        }

        struct Response {
            let post: [DisplayedPost]
        }

        struct ViewModel {
            let displayedPost: [DisplayedPost]
        }
    }

    enum FetchMorePosts {
        struct Request {
        }

        struct Response {
            let post: [DisplayedPost]
        }

        struct ViewModel {
            let displayedPost: [DisplayedPost]
        }
    }

    enum FetchTitleTag {
        struct Request {
        }

        struct Response {
            let titleTag: String
        }

        struct ViewModel {
            let title: String
        }
    }
}
