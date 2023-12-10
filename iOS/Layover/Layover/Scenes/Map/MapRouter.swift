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
    func routeToEditVideo()
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
              var destination = playbackViewController.router?.dataStore
        else { return }
        passDataToPlayback(source: source, destination: &destination)
        viewController?.navigationController?.pushViewController(playbackViewController, animated: true)
    }

    func routeToEditVideo() {
        let nextViewController = EditVideoViewController()
        guard let source = dataStore,
              var destination = nextViewController.router?.dataStore else { return }
        passDataToEditVideo(source: source, destination: &destination)
        viewController?.navigationController?.pushViewController(nextViewController, animated: true)
    }

    private func passDataToEditVideo(source: MapDataStore, destination: inout EditVideoDataStore) {
        destination.videoURL = source.selectedVideoURL
    }

    private func passDataToPlayback(source: MapDataStore, destination: inout PlaybackDataStore) {
        destination.posts = source.posts
        destination.index = source.postPlayStartIndex
        destination.parentView = .map
    }
}
