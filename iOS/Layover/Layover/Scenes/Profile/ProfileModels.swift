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

    struct DisplayedPost: Hashable, Identifiable {
        let uuid = UUID()
        let id: Int
        let thumbnailImageData: Data?
        let status: BoardStatus
    }

    enum FetchProfile {

        struct Request {
        }

        struct Response {
            let userProfile: Profile
            let displayedPosts: [DisplayedPost]
        }

        struct ViewModel {
            let userProfile: Profile
            let displayedPosts: [DisplayedPost]
        }
    }

    enum FetchMorePosts {
        struct Request {
        }

        struct Response {
            let displayedPosts: [DisplayedPost]
        }

        struct ViewModel {
            let displayedPosts: [DisplayedPost]
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
