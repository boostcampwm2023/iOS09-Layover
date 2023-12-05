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

    struct Post: Hashable {
        let id: Int
        let thumbnailImageData: Data?
    }

    enum FetchProfile {

        struct Request {
        }

        struct Response {
            let userProfile: Profile
            let posts: [Post]
        }

        struct ViewModel {
            let userProfile: Profile
            let posts: [Post]
        }
    }

    enum FetchMorePosts {

        struct Request {
        }

        struct Response {
            let posts: [Post]
        }

        struct ViewModel {
            let posts: [Post]
        }
    }
}
