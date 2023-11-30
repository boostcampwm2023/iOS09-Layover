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
            var editedVideoURL: URL?
        }
        struct Response {
            var isEdited: Bool
            var videoURL: URL
            var duration: Double
            var isWithinRange: Bool
        }
        struct ViewModel {
            var isEdited: Bool
            var videoURL: URL
            var duration: Double
            var canNext: Bool
        }
    }

}
