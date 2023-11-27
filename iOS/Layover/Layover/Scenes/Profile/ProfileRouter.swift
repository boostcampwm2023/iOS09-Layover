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
}

protocol ProfileDataPassing {
    var dataStore: ProfileDataStore? { get }
}

class ProfileRouter: NSObject, ProfileRoutingLogic, ProfileDataPassing {

    // MARK: - Properties

    weak var viewController: ProfileViewController?
    var dataStore: ProfileDataStore?

    // MARK: - Routing

    func routeToEditProfileViewController() {
        let editProfileViewController = EditProfileViewController()
        guard let source = dataStore,
              var destination = editProfileViewController.router?.dataStore
        else { return }

        passProfileDataToEditProfile(source: source, destination: &destination)
        viewController?.navigationController?.pushViewController(editProfileViewController, animated: true)
    }

    // MARK: - Data Passing

    private func passProfileDataToEditProfile(source: ProfileDataStore, destination: inout EditProfileDataStore) {
        destination.nickname = source.nickname
        destination.introduce = source.introduce
        destination.profileImageURL = source.profileImageURL
    }
}
