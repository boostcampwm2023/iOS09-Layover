//
//  ProfileRouter.swift
//  Layover
//
//  Created by kong on 2023/11/21.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol ProfileRoutingLogic {
    func routeToEditProfile()
    func routeToSetting()
    func routeToPlayback()
}

protocol ProfileDataPassing {
    var dataStore: ProfileDataStore? { get }
}

final class ProfileRouter: ProfileRoutingLogic, ProfileDataPassing {

    // MARK: - Properties

    weak var viewController: ProfileViewController?
    var dataStore: ProfileDataStore?

    // MARK: - Routing

    func routeToEditProfile() {
        let editProfileViewController = EditProfileViewController()
        guard let source = dataStore,
              var destination = editProfileViewController.router?.dataStore
        else { return }

        // Data Passing
        passDataToEditProfile(source: source, destination: &destination)
        editProfileViewController.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(editProfileViewController, animated: true)
    }

    func routeToSetting() {
        let settingViewController: SettingViewController = SettingViewController()
        viewController?.navigationController?.pushViewController(settingViewController, animated: true)
    }

    func routeToPlayback() {
        let playbackViewController = PlaybackViewController()
        guard let source = dataStore,
              var destination = playbackViewController.router?.dataStore
        else { return }
        passDataToPlayback(source: source, destination: &destination)
        viewController?.navigationController?.pushViewController(playbackViewController, animated: true)
    }

    // MARK: - Data Passing

    private func passDataToEditProfile(source: ProfileDataStore, destination: inout EditProfileDataStore) {
        destination.nickname = source.nickname
        destination.introduce = source.introduce
        destination.profileImageData = source.profileImageData
    }

    private func passDataToPlayback(source: ProfileDataStore, destination: inout PlaybackDataStore) {
        destination.posts = source.posts
        destination.index = source.playbackStartIndex
    }
}
