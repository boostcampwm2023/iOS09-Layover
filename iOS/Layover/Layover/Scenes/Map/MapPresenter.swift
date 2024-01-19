//
//  MapPresenter.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol MapPresentationLogic {
    func presentCurrentLocation()
    func presentDefaultLocation()
    func presentFetchedPosts(with response: MapModels.FetchPosts.Response)
    func presentPlaybackScene()
    func presentUploadScene()
    func presentSetting()
}

final class MapPresenter: MapPresentationLogic {

    // MARK: - Properties

    typealias Models = MapModels
    weak var viewController: MapDisplayLogic?

    func presentCurrentLocation() {
        viewController?.displayCurrentLocation()
    }

    func presentDefaultLocation() {
        viewController?.displayDefaultLocation(viewModel: MapModels.CheckLocationAuthorizationOnEntry.ViewModel())
    }

    func presentFetchedPosts(with response: MapModels.FetchPosts.Response) {
        let displayedPost = response.posts
            .map { post -> Models.DisplayedPost? in
                return .init(boardID: post.board.identifier,
                             thumbnailImageURL: post.board.thumbnailImageURL,
                             videoURL: post.board.videoURL,
                             latitude: post.board.latitude,
                             longitude: post.board.longitude,
                             boardStatus: post.board.status)
            }.compactMap { $0 }

        let viewModel = Models.FetchPosts.ViewModel(displayedPosts: displayedPost)
        viewController?.displayFetchedPosts(viewModel: viewModel)
    }

    func presentPlaybackScene() {
        viewController?.routeToPlayback()
    }

    func presentUploadScene() {
        viewController?.routeToVideoPicker()
    }

    func presentSetting() {
        viewController?.openSetting()
    }
}
