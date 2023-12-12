//
//  ProfileModels.swift
//  Layover
//
//  Created by kong on 2023/11/21.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

enum ProfileModels {

    struct Profile: Hashable {
        let username: String
        let introduce: String?
        let profileImageData: Data?
    }

    struct DisplayedPost: Hashable {
        let id: Int
        let thumbnailImageData: Data?
        let status: BoardStatus
    }

    enum FetchProfile {

        struct Request {
        }

        struct Response {
            let userProfile: Profile
            let posts: [DisplayedPost]
        }

        struct ViewModel {
            let userProfile: Profile
            let posts: [DisplayedPost]
        }
    }

    enum FetchMorePosts {
        struct Request {
        }

        struct Response {
            let posts: [DisplayedPost]
        }

        struct ViewModel {
            let posts: [DisplayedPost]
        }
    }

    enum ShowPostDetail {
        struct Request {
            let startIndex: Int
        }

        struct Response {
        }

        struct ViewModel {
        }
    }
}
