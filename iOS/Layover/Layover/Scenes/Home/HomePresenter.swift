//
//  HomePresenter.swift
//  Layover
//
//  Created by 김인환 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol HomePresentationLogic {
    func presentPosts(with response: HomeModels.FetchPosts.Response)
    func presentPlaybackScene(with response: HomeModels.PlayPosts.Response)
    func presentTagPlayList(with response: HomeModels.ShowTagPlayList.Response)
    func presentUploadScene()
    func presentSetting()
}

final class HomePresenter: HomePresentationLogic {

    // MARK: - Properties

    typealias Models = HomeModels
    weak var viewController: HomeDisplayLogic?

    // MARK: - Use Case - Home

    func presentPosts(with response: Models.FetchPosts.Response) {
        var displayedPosts = [Models.DisplayedPost]()

        for post in response.posts {
            guard let thumbnailURL = post.board.thumbnailImageURL,
                  let videoURL = post.board.videoURL else { continue }

            let displayedPost = Models.DisplayedPost(thumbnailImageURL: thumbnailURL,
                                                     videoURL: videoURL,
                                                     title: post.board.title,
                                                     tags: post.tag)
            displayedPosts.append(displayedPost)
        }

        let viewModel = Models.FetchPosts.ViewModel(displayedPosts: displayedPosts)
        viewController?.displayPosts(with: viewModel)
    }

    // MARK: - UseCase Present PlaybackScene

    func presentPlaybackScene(with response: HomeModels.PlayPosts.Response) {
        viewController?.routeToPlayback()
    }

    // MARK: - UseCase - TagPlayList

    func presentTagPlayList(with response: HomeModels.ShowTagPlayList.Response) {
        viewController?.routeToTagPlayList()
    }

    func presentUploadScene() {
        viewController?.routeToVideoPicker()
    }

    func presentSetting() {
        viewController?.openSetting()
    }
}
