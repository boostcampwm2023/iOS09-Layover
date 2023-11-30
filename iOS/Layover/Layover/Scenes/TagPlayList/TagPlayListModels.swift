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

    struct DisplayedPost {
        let thumbnailImageData: Data?
        let title: String
    }

    enum FetchPosts {
        struct Request {
            let tag: String
        }

        struct Response {
            let post: [DisplayedPost]
        }

        struct ViewModel {
            let displayedPost: [DisplayedPost]
        }
    }
}
