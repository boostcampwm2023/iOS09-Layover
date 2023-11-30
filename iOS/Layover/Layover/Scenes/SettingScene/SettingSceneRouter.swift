//
//  SettingSceneRouter.swift
//  Layover
//
//  Created by 황지웅 on 11/30/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol SettingSceneRoutingLogic {
}

protocol SettingSceneDataPassing {
    var dataStore: SettingSceneDataStore? { get }
}

final class SettingSceneRouter: NSObject, SettingSceneRoutingLogic, SettingSceneDataPassing {

    // MARK: - Properties

    weak var viewController: SettingSceneViewController?
    var dataStore: SettingSceneDataStore?

    // MARK: - Routing

}
