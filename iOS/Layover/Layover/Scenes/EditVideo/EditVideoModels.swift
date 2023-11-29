//
//  EditVideoModels.swift
//  Layover
//
//  Created by kong on 2023/11/29.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

enum EditVideoModels {

    enum FetchVideo {
        struct Request {

        }
        struct Response {
            var videoURL: URL
        }
        struct ViewModel {
            var videoURL: URL
        }
    }

}
