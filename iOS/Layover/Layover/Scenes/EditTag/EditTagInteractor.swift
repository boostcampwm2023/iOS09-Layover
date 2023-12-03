//
//  EditTagInteractor.swift
//  Layover
//
//  Created by kong on 2023/12/03.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditTagBusinessLogic {

}

protocol EditTagDataStore {

}

class EditTagInteractor: EditTagBusinessLogic, EditTagDataStore {

    // MARK: - Properties

    typealias Models = EditTagModels

    var presenter: EditTagPresentationLogic?

}
