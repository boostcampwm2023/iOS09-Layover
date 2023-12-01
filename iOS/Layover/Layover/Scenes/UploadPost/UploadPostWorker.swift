//
//  UploadPostWorker.swift
//  Layover
//
//  Created by kong on 2023/12/01.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

class UploadPostWorker {

    // MARK: - Properties

    typealias Models = UploadPostModels

    // MARK: - Methods

    // MARK: Screen Specific Validation

    func validate(exampleVariable: String?) -> Models.UploadPostError? {
        var error: Models.UploadPostError?

        if exampleVariable?.isEmpty == false {
            error = nil
        } else {
            error = Models.UploadPostError(type: .emptyExampleVariable)
        }

        return error
    }
}
