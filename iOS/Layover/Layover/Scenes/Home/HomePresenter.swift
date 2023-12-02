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
    func presentThumbnailImage(with response: HomeModels.FetchThumbnailImageData.Response)
    func presentPlaybackScene()
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

    func presentThumbnailImage(with response: Models.FetchThumbnailImageData.Response) {
        let viewModel = Models.FetchThumbnailImageData.ViewModel(imageData: response.imageData,
                                                                 indexPath: response.indexPath)
        viewController?.displayThumbnailImage(with: viewModel)
    }

    // MARK: - UseCase Present PlaybackScene

    func presentPlaybackScene() {
        viewController?.routeToPlayback()
    }
}
