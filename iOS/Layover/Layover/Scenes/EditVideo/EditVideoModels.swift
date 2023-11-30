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
            let editedVideoURL: URL?
        }
        struct Response {
            let isEdited: Bool
            let videoURL: URL
            let duration: Double
            let isWithinRange: Bool
        }
        struct ViewModel {
            let isEdited: Bool
            let videoURL: URL
            let duration: Double
            let canNext: Bool
        }
    }

}
