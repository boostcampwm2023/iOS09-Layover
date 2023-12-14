//
//  TagPlayListRouter.swift
//  Layover
//
//  Created by 김인환 on 11/29/23.
//  Copyright (c) 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol TagPlayListRoutingLogic {
    func routeToPlayback()
}

protocol TagPlayListDataPassing {
    var dataStore: TagPlayListDataStore? { get }
}

final class TagPlayListRouter: TagPlayListRoutingLogic, TagPlayListDataPassing {

    // MARK: - Properties

    weak var viewController: TagPlayListViewController?
    var dataStore: TagPlayListDataStore?

    func routeToPlayback() {
        let playbackViewController: PlaybackViewController = PlaybackViewController()
        guard let source = dataStore,
              var destination = playbackViewController.router?.dataStore else { return }

        passDataToPlayback(source: source, destination: &destination)
        viewController?.navigationController?.pushViewController(playbackViewController, animated: true)
    }

    private func passDataToPlayback(source: TagPlayListDataStore, destination: inout PlaybackDataStore) {
        destination.parentView = .tag
        destination.index = source.postPlayStartIndex
        destination.posts = source.posts
    }
}
