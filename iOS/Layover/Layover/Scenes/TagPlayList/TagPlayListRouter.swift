//
//  TagPlayListRouter.swift
//  Layover
//
//  Created by 김인환 on 11/29/23.
//  Copyright (c) 2023 CodeBomber. All rights reserved.
//

import UIKit

@objc protocol TagPlayListRoutingLogic {

}

protocol TagPlayListDataPassing {
    var dataStore: TagPlayListDataStore? { get }
}

final class TagPlayListRouter: TagPlayListRoutingLogic, TagPlayListDataPassing {

    // MARK: - Properties

    weak var viewController: TagPlayListViewController?
    var dataStore: TagPlayListDataStore?
}
