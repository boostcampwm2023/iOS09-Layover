//
//  EditTagModels.swift
//  Layover
//
//  Created by kong on 2023/12/03.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

enum EditTagModels {

    static let maxTagCount: Int = 3
    static let maxTagLength: Int = 5

    enum FetchTags {
        struct Request {

        }
        struct Response {
            let tags: [String]
        }
        struct ViewModel {
            let tags: [String]
            var tagCountDescription: String
        }
    }

    enum AddTag {
        struct Request {
            let tags: [String]
            let newTag: String
        }
        struct Response {
            let tags: [String]
            let addedTag: String?
        }
        struct ViewModel {
            let addedTag: String?
            let tagCountDescription: String
        }
    }

    enum EditTags {
        struct Request {
            let editedTags: [String]
        }
        struct Response {
            let editedTags: [String]
        }
        struct ViewModel {
            let tagCountDescription: String
        }
    }

}
