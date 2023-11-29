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

    enum FetchPosts {
        struct Request {
            let tag: String
        }

        struct Response {
            let post: [Post]
        }

        struct ViewModel {
            struct DisplayedPost {
                let thumbnailImage: Data?
                let title: String
            }
            let displayedPost: [DisplayedPost]
        }
    }
}
