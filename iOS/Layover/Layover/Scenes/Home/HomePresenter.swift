//
//  HomePresenter.swift
//  Layover
//
//  Created by 김인환 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol HomePresentationLogic {
    func presentVideoURL(with response: HomeModels.CarouselVideos.Response)
    func presentPlaybackScene()
}

final class HomePresenter: HomePresentationLogic {

    // MARK: - Properties

    typealias Models = HomeModels
    weak var viewController: HomeDisplayLogic?

    // MARK: - Use Case - Home

    func presentVideoURL(with response: HomeModels.CarouselVideos.Response) {
        let viewModel = HomeModels.CarouselVideos.ViewModel(videoURLs: response.videoURLs)
        viewController?.displayVideoURLs(with: viewModel)
    }

    // MARK: - UseCase Present PlaybackScene

    func presentPlaybackScene() {
        viewController?.routeToPlayback()
    }
}
