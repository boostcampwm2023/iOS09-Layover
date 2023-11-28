//
//  PlaybackModels.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

enum PlaybackModels {
    
    struct Board: Hashable {
        var id: UUID = UUID()
        let title: String
        let content: String
        let tags: [String]
        let sdUrl: URL
        let hdURL: URL
        let memeber: MemberDTO
    }

    // MARK: - Use Cases
    
    enum ParentView {
        case home
        case other
    }

    enum PlaybackVideoList {
        struct Request {
        }

        struct Response {
            let videos: [Board]
        }

        struct ViewModel {
            let videos: [Board]
        }
    }

}
