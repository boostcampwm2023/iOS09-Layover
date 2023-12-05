//
//  ReportModels.swift
//  Layover
//
//  Created by 황지웅 on 12/4/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

enum ReportModels {

    // MARK: - Use Cases

    enum ReportPlaybackVideo {
        struct Request {
            let reportContent: String
        }

        struct Response {
            let reportResult: Bool
        }

        struct ViewModel {
            let reportMessage: String
        }
    }
}
