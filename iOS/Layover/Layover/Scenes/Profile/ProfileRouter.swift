//
//  ProfileRouter.swift
//  Layover
//
//  Created by kong on 2023/11/21.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol ProfileRoutingLogic {
    func routeToEditProfileViewController()
    func routeToSettingViewController()
}

protocol ProfileDataPassing {
    var dataStore: ProfileDataStore? { get }
}

final class ProfileRouter: NSObject, ProfileRoutingLogic, ProfileDataPassing {

    // MARK: - Properties

    weak var viewController: ProfileViewController?
    var dataStore: ProfileDataStore?

    // MARK: - Routing

    func routeToEditProfileViewController() {
        let editProfileViewController = EditProfileViewController()
        guard let source = dataStore,
              var destination = editProfileViewController.router?.dataStore
        else { return }

        // Data Passing
        destination.nickname = source.nickname
        destination.introduce = source.introduce
        destination.profileImage = source.profileImage
        editProfileViewController.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(editProfileViewController, animated: true)
    }

    func routeToSettingViewController() {
        let settingSceneViewController = SettingViewController()
        viewController?.navigationController?.pushViewController(settingSceneViewController, animated: true)
    }
}
