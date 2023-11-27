//
//  EditProfileInteractor.swift
//  Layover
//
//  Created by kong on 2023/11/27.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditProfileBusinessLogic {

}

protocol EditProfileDataStore {

}

class EditProfileInteractor: EditProfileBusinessLogic, EditProfileDataStore {

    // MARK: - Properties

    typealias Models = EditProfileModels

    lazy var worker = EditProfileWorker()
    var presenter: EditProfilePresentationLogic?

    // MARK: - Use Case - Fetch From Local DataStore

}
