//
//  UploadPostModels.swift
//  Layover
//
//  Created by kong on 2023/12/01.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

enum UploadPostModels {

    static let titleMaxLength: Int = 15
    static let contentMaxLength: Int = 50

    enum CanUploadPost {
        struct Request {
            let title: String?
        }
        struct Response {
            let isEmpty: Bool
        }
        struct ViewModel {
            let canUpload: Bool
        }
    }

    enum FetchTags {
        struct Request {

        }
        struct Response {
            let tags: [String]
        }

        struct ViewModel {
            let tags: [String]
        }
    }

    enum EditTags {
        struct Request {
            let tags: [String]
        }
    }

    enum FetchThumbnail {
        struct Request {

        }
        struct Response {
            let thumbnailImage: CGImage
        }
        struct ViewModel {
            let thumbnailImage: UIImage
        }
    }

    enum FetchCurrentAddress {
        struct Request {

        }
        struct Response {
            let administrativeArea: String?
            let locality: String?
            let subLocality: String?
        }
        struct ViewModel {
            let fullAddress: String
        }
    }

    enum UploadPost {
        struct Request {
            let title: String
            let content: String?
            let tags: [String]
        }
        struct Response {

        }
        struct VideModel {

        }
    }

}
