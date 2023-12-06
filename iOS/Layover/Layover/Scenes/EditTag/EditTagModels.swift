//
//  EditTagModels.swift
//  Layover
//
//  Created by kong on 2023/12/03.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

enum EditTagModels {

    enum FetchTags {
        struct Request {

        }
        struct Response {
            let tags: [String]
        }
        struct ViewModel {
            let tags: [String]
        }
    }

    enum EditTag {
        struct Request {
            let tags: [String]
        }
    }

}
