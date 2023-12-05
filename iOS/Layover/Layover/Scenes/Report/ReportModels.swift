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
        enum ReportMessage {
            case success
            case fail

            var description: String {
                switch self {
                case .success:
                    "신고가 접수되었습니다."
                case .fail:
                    "신고 접수에 실패했습니다. 다시 시도해주세요."
                }
            }
        }
        struct Request {
            let reportContent: String
        }

        struct Response {
            let reportResult: Bool
        }

        struct ViewModel {
            let reportMessage: ReportMessage
        }
    }
}
