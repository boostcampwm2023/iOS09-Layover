//
//  ProfileInteractor.swift
//  Layover
//
//  Created by kong on 2023/11/21.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol ProfileBusinessLogic {

}

protocol ProfileDataStore {

}

class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {

    // MARK: - Properties

    typealias Models = ProfileModels

    var presenter: ProfilePresentationLogic?

}
