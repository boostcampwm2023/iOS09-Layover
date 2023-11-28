//
//  PlaybackPresenter.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol PlaybackPresentationLogic {
    func presentVideoList(with response: PlaybackModels.PlaybackVideoList.Response)
}

final class PlaybackPresenter: PlaybackPresentationLogic {


    // MARK: - Properties

    typealias Models = PlaybackModels
    weak var viewController: PlaybackDisplayLogic?

    // MARK: - UseCase 비디오 목록 출력

    func presentVideoList(with response: PlaybackModels.PlaybackVideoList.Response) {
        let viewModel: Models.PlaybackVideoList.ViewModel = Models.PlaybackVideoList.ViewModel(videos: response.videos)
        viewController?.displayVideoList(viewModel: viewModel)
    }

}
