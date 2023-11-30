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
            var videoRange: ClosedRange<Double> = 3.0...60.0
        }
        struct Response {
            let isEdited: Bool
            let videoURL: URL
            let duration: Double
            var isWithinRange: Bool
        }
        struct ViewModel {
            let isEdited: Bool
            let videoURL: URL
            let duration: Double
            let canNext: Bool
        }
    }

}
