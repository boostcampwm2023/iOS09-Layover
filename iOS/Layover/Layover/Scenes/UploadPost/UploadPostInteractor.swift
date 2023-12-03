//
//  UploadPostInteractor.swift
//  Layover
//
//  Created by kong on 2023/12/01.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol UploadPostBusinessLogic {

}

protocol UploadPostDataStore {

}

class UploadPostInteractor: UploadPostBusinessLogic, UploadPostDataStore {

    // MARK: - Properties

    typealias Models = UploadPostModels

    lazy var worker = UploadPostWorker()
    var presenter: UploadPostPresentationLogic?

}
