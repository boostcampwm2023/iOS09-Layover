//
//  ProfileModels.swift
//  Layover
//
//  Created by kong on 2023/11/21.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

enum ProfileModels {

    struct Member: Hashable {
        let identifier: Int
        let username: String
        let introduce: String?
        let profileImageURL: URL?
    }

    enum FetchProfile {
        struct Request {

        }

        struct Response {
            let nickname: String
            let introduce: String?
            let profileImageURL: URL?
            // video data
        }

        struct ViewModel {
            let nickname: String
            let introduce: String?
            let profileImageURL: URL?
            // video data
        }
    }
}
