//
//  PlaybackModels.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

enum PlaybackModels {

    // MARK: - Use Cases

    enum PlaybackVideoList {
        struct Request {

        }

        struct Response {

        }

        struct ViewModel {
            enum ParentView {
                case home
                case other
            }
            let parentView: ParentView
            let videos: [VideoDTO]
        }
    }

}
