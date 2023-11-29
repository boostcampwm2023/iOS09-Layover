//
//  TagPlayListInteractor.swift
//  Layover
//
//  Created by 김인환 on 11/29/23.
//  Copyright (c) 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol TagPlayListBusinessLogic {

}

protocol TagPlayListDataStore {
}

final class TagPlayListInteractor: TagPlayListBusinessLogic, TagPlayListDataStore {

    // MARK: - Properties

    var presenter: TagPlayListPresentationLogic?
    var worker: TagPlayListWorker?


}
