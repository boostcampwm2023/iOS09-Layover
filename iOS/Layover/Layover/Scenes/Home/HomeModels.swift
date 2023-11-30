//
//  HomeModels.swift
//  Layover
//
//  Created by 김인환 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

enum HomeModels {

    // MARK: - Use Cases

    enum CarouselVideos {
        struct Request {
        }

        struct Response {
            let videoURLs: [URL]
        }

        struct ViewModel {
            let videoURLs: [URL]
        }
    }

    enum SelectVideo {
        struct Request {
            let videoURL: URL
        }

        struct Response {

        }

        struct ViewModel {

        }
    }
}
