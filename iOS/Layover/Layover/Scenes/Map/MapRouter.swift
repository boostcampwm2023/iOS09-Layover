//
//  MapRouter.swift
//  Layover
//
//  Created by 황지웅 on 11/29/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol MapRoutingLogic {
    func routeToPlayback()
}

protocol MapDataPassing {
    var dataStore: MapDataStore? { get }
}

final class MapRouter: MapRoutingLogic, MapDataPassing {

    // MARK: - Properties

    weak var viewController: MapViewController?
    var dataStore: MapDataStore?

    // MARK: - Routing

    func routeToPlayback() {
        let playbackViewController: PlaybackViewController = PlaybackViewController()
        guard let source = dataStore,
              let destination = playbackViewController.router?.dataStore
        else { return }
        destination.parentView = .other
        destination.index = source.index
        destination.videos = transData(videos: source.videos ?? [])
        viewController?.navigationController?.pushViewController(playbackViewController, animated: true)
    }

    private func transData(videos: [Post]) -> [PlaybackModels.PlaybackVideo] {
        videos.map { video in
            return PlaybackModels.PlaybackVideo(post: video)
        }
    }

}
