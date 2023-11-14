//
//  LoginWorker.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import UIKit

class LoginWorker {

    // MARK: - Properties

    typealias Models = LoginModels

    // MARK: - Methods

    // MARK: Screen Specific Validation

    func validate(exampleVariable: String?) -> Models.LoginError? {
        var error: Models.LoginError?

        if exampleVariable?.isEmpty == false {
            error = nil
        } else {
            error = Models.LoginError(type: .emptyExampleVariable)
        }

        return error
    }
}
