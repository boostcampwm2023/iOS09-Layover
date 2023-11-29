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
        destination.videos = transDTO(videos: source.videos ?? [])
        viewController?.navigationController?.pushViewController(playbackViewController, animated: true)
    }

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

}
