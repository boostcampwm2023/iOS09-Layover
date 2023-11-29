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

    func routeToPlayback() {
        let playbackViewController: PlaybackViewController = PlaybackViewController()
        guard let source = dataStore,
              let destination = playbackViewController.router?.dataStore
        else { return }
        destination.parentView = .home
        destination.videos = transDTO(videos: source.videos ?? [])
        viewController?.navigationController?.pushViewController(playbackViewController, animated: true)
    }

    // Interactor가 해줄 역할? 고민 필요
    private func transDTO(videos: [VideoDTO]) -> [PlaybackModels.Board] {
        videos.map { videoDTO in
            return PlaybackModels.Board(
                title: videoDTO.title,
                content: videoDTO.content,
                tags: videoDTO.tags,
                sdUrl: videoDTO.sdURL,
                hdURL: videoDTO.hdURL,
                memeber: videoDTO.member)
        }
    }
    // MARK: - Data Passing

    // func passDataTo(_ destinationDS: inout NextDataStore, from sourceDS: HomeDataStore) {
    //     destinationDS.attribute = sourceDS.attribute
    // }
}
