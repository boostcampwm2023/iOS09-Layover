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
    func routeToPlayback()
    func routeToEditVideo()
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

final class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing {

    // MARK: - Properties

    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?

    // MARK: - Routing

    func routeToNext() {
        let nextViewController = MainTabBarViewController()
        viewController?.navigationController?.setViewControllers([nextViewController], animated: true)
    }

    func routeToEditVideo() {
        let nextViewController = EditVideoViewController()
        guard let source = dataStore,
              var destination = nextViewController.router?.dataStore,
              let videoURL = source.selectedVideoURL
        else { return }

        // Data Passing
        destination.videoURL = videoURL
        nextViewController.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(nextViewController, animated: true)
    }

    func routeToPlayback() {
        let playbackViewController: PlaybackViewController = PlaybackViewController()
        guard let source = dataStore,
              let destination = playbackViewController.router?.dataStore
        else { return }
        destination.parentView = .home
        destination.index = source.index
        destination.videos = transData(videos: source.videos ?? [])
        viewController?.navigationController?.pushViewController(playbackViewController, animated: true)
    }

    private func transData(videos: [Post]) -> [PlaybackModels.PlaybackVideo] {
        videos.map { video in
            return PlaybackModels.PlaybackVideo(post: video)
        }
    }

    // MARK: - Data Passing

    // func passDataTo(_ destinationDS: inout NextDataStore, from sourceDS: HomeDataStore) {
    //     destinationDS.attribute = sourceDS.attribute
    // }
}
