//
//  PlaybackWorker.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

class PlaybackWorker {

    // MARK: - Properties

    typealias Models = PlaybackModels

    // MARK: - Methods

    // MARK: Screen Specific Validation

    func validate(exampleVariable: String?) -> Models.PlaybackError? {
        var error: Models.PlaybackError?

        if exampleVariable?.isEmpty == false {
            error = nil
        } else {
            error = Models.PlaybackError(type: .emptyExampleVariable)
        }

        return error
    }
}
