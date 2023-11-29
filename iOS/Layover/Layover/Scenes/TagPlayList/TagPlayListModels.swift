//
//  TagPlayListModels.swift
//  Layover
//
//  Created by 김인환 on 11/29/23.
//  Copyright (c) 2023 CodeBomber. All rights reserved.
//

import UIKit

enum TagPlayListModels {
    // MARK: Use cases

    enum FetchPlayList {
        struct Request {
        }

        struct Response {
            let playList: [PlayList]
        }

        struct ViewModel {
        }
    }
}
