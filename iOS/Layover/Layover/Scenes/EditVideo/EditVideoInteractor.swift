//
//  EditVideoInteractor.swift
//  Layover
//
//  Created by kong on 2023/11/29.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditVideoBusinessLogic {

}

protocol EditVideoDataStore {

}

final class EditVideoInteractor: EditVideoBusinessLogic, EditVideoDataStore {

    // MARK: - Properties

    typealias Models = EditVideoModels

    lazy var worker = EditVideoWorker()
    var presenter: EditVideoPresentationLogic?

    var exampleVariable: String?

}
