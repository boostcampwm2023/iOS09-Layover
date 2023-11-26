//
//  HomeRouter.swift
//  Layover
//
//  Created by 김인환 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol HomeRoutingLogic {
    func routeToNext()
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing {

    // MARK: - Properties

    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?

    // MARK: - Routing

    func routeToNext() {
        let nextViewController = MainTabBarViewController()
        viewController?.navigationController?.setViewControllers([nextViewController], animated: true)
    }

    // MARK: - Data Passing

    // func passDataTo(_ destinationDS: inout NextDataStore, from sourceDS: HomeDataStore) {
    //     destinationDS.attribute = sourceDS.attribute
    // }
}
