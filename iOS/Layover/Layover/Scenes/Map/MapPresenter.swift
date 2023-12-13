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
}

final class MapPresenter: MapPresentationLogic {

    // MARK: - Properties

    typealias Models = MapModels
    weak var viewController: MapDisplayLogic?

    func presentCurrentLocation() {
        // TODO: 현재 위치 사용 가능
    }

    func presentDefaultLocation() {
        // TODO: 위치 관련 기능 사용 불가, 디폴트 위치로 이동
    }

    func presentFetchedPosts(with response: MapModels.FetchPosts.Response) {
        let displayedPost = response.posts
            .map { post -> Models.DisplayedPost? in
                return .init(boardID: post.board.identifier,
                             thumbnailImageData: post.thumbnailImageData,
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
}
