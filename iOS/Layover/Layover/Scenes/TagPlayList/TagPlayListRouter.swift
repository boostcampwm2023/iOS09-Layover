//
//  TagPlayListRouter.swift
//  Layover
//
//  Created by 김인환 on 11/29/23.
//  Copyright (c) 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol TagPlayListRoutingLogic {
    
}

protocol TagPlayListDataPassing {
    var dataStore: TagPlayListDataStore? { get }
}

final class TagPlayListRouter: TagPlayListRoutingLogic, TagPlayListDataPassing {

    // MARK: - Properties

    var titleTag: String?
    

    weak var viewController: TagPlayListViewController?
    var dataStore: TagPlayListDataStore?
}
