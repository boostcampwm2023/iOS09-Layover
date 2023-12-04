//
//  UploadPostModels.swift
//  Layover
//
//  Created by kong on 2023/12/01.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

enum UploadPostModels {

    enum FetchThumbnail {
        struct Request {

        }
        struct Response {
            let thumnailImage: CGImage
        }
        struct ViewModel {
            let thumnailImage: UIImage
        }
    }

    enum UploadPost {
        struct Request {
            let title: String
            let content: String?
            let latitude: Double
            let longitude: Double
            let tags: [String]
        }
        struct Response {

        }
        struct VideModel {

        }
    }

}
