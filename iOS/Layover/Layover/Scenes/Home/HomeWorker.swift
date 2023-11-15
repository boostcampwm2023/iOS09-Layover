//
//  HomeWorker.swift
//  Layover
//
//  Created by 김인환 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

class HomeWorker {

    // MARK: - Properties

    typealias Models = HomeModels

    // MARK: - Methods

    // MARK: Screen Specific Validation

    func validate(exampleVariable: String?) -> Models.HomeError? {
        var error: Models.HomeError?

        if exampleVariable?.isEmpty == false {
            error = nil
        } else {
            error = Models.HomeError(type: .emptyExampleVariable)
        }

        return error
    }
}
