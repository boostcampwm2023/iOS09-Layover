//
//  PlaybackPresenter.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol PlaybackPresentationLogic {
    func presentVideoList(with response: PlaybackModels.LoadPlaybackVideoList.Response)
    func presentSetCellIfInfinite()
    func presentMoveCellInfinite()
    func presentMoveCellNext(with response: PlaybackModels.LoadPlaybackVideoList.Response)
    func presentSetInitialPlaybackCell(with response: PlaybackModels.SetInitialPlaybackCell.Response)
    func presentPlayInitialPlaybackCell(with response: PlaybackModels.DisplayPlaybackVideo.Response)
    func presentHidePlayerSlider(with response: PlaybackModels.DisplayPlaybackVideo.Response)
}

final class PlaybackPresenter: PlaybackPresentationLogic {

    // MARK: - Properties

    typealias Models = PlaybackModels
    weak var viewController: PlaybackDisplayLogic?

    // MARK: - UseCase 비디오 목록 출력

    func presentVideoList(with response: PlaybackModels.LoadPlaybackVideoList.Response) {
        let viewModel: Models.LoadPlaybackVideoList.ViewModel = Models.LoadPlaybackVideoList.ViewModel(videos: response.videos)
        viewController?.displayVideoList(viewModel: viewModel)
    }

    func presentSetCellIfInfinite() {
        viewController?.displayMoveCellIfinfinite()
    }

    func presentMoveCellNext(with response: PlaybackModels.LoadPlaybackVideoList.Response) {
//        viewController
    }

    func presentMoveCellInfinite() {
        //
    }

    func presentSetInitialPlaybackCell(with response: PlaybackModels.SetInitialPlaybackCell.Response) {
        let viewModel: Models.SetInitialPlaybackCell.ViewModel = Models.SetInitialPlaybackCell.ViewModel(indexPathRow: response.indexPathRow)
        viewController?.setInitialPlaybackCell(viewModel: viewModel)
    }

    func presentPlayInitialPlaybackCell(with response: PlaybackModels.DisplayPlaybackVideo.Response) {
        let viewModel: Models.DisplayPlaybackVideo.ViewModel = Models.DisplayPlaybackVideo.ViewModel(prevCell: nil, curCell: response.curCell)
        viewController?.stopPrevPlayerAndPlayCurPlayer(viewModel: viewModel)
    }

    func presentHidePlayerSlider(with response: PlaybackModels.DisplayPlaybackVideo.Response) {
        let viewModel: Models.DisplayPlaybackVideo.ViewModel = Models.DisplayPlaybackVideo.ViewModel(prevCell: response.prevCell, curCell: nil)
        viewController?.hidePlayerSlider(viewModel: viewModel)
    }
}
