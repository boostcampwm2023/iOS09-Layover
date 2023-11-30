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
    func presentMoveCellNext(with response: PlaybackModels.DisplayPlaybackVideo.Response)
    func presentSetInitialPlaybackCell(with response: PlaybackModels.SetInitialPlaybackCell.Response)
    func presentMoveInitialPlaybackCell(with response: PlaybackModels.SetInitialPlaybackCell.Response)
    func presentPlayInitialPlaybackCell(with response: PlaybackModels.DisplayPlaybackVideo.Response)
    func presentHidePlayerSlider(with response: PlaybackModels.DisplayPlaybackVideo.Response)
    func presentShowPlayerSlider(with response: PlaybackModels.DisplayPlaybackVideo.Response)
    func presentTeleportCell(with response: PlaybackModels.DisplayPlaybackVideo.Response)
    func presentLeavePlaybackView(with response: PlaybackModels.DisplayPlaybackVideo.Response)
}

final class PlaybackPresenter: PlaybackPresentationLogic {

    // MARK: - Properties

    typealias Models = PlaybackModels
    weak var viewController: PlaybackDisplayLogic?

    // MARK: - UseCase Load Video List

    func presentVideoList(with response: PlaybackModels.LoadPlaybackVideoList.Response) {
        let viewModel: Models.LoadPlaybackVideoList.ViewModel = Models.LoadPlaybackVideoList.ViewModel(videos: response.videos)
        viewController?.displayVideoList(viewModel: viewModel)
    }

    func presentSetCellIfInfinite() {
        viewController?.displayMoveCellIfinfinite()
    }

    // MARK: - UseCase Set Init Playback Scene

    func presentSetInitialPlaybackCell(with response: PlaybackModels.SetInitialPlaybackCell.Response) {
        let viewModel: Models.SetInitialPlaybackCell.ViewModel = Models.SetInitialPlaybackCell.ViewModel(indexPathRow: response.indexPathRow)
        viewController?.setInitialPlaybackCell(viewModel: viewModel)
    }

    func presentMoveInitialPlaybackCell(with response: PlaybackModels.SetInitialPlaybackCell.Response) {
        let viewModel: Models.SetInitialPlaybackCell.ViewModel = Models.SetInitialPlaybackCell.ViewModel(indexPathRow: response.indexPathRow)
        viewController?.moveInitialPlaybackCell(viewModel: viewModel)
    }

    // MARK: - UseCase Playback Video

    func presentMoveCellNext(with response: PlaybackModels.DisplayPlaybackVideo.Response) {
        let viewModel: Models.DisplayPlaybackVideo.ViewModel = Models.DisplayPlaybackVideo.ViewModel(prevCell: response.prevCell, curCell: response.curCell)
        viewController?.stopPrevPlayerAndPlayCurPlayer(viewModel: viewModel)
    }

    func presentPlayInitialPlaybackCell(with response: PlaybackModels.DisplayPlaybackVideo.Response) {
        let viewModel: Models.DisplayPlaybackVideo.ViewModel = Models.DisplayPlaybackVideo.ViewModel(prevCell: nil, curCell: response.curCell)
        viewController?.stopPrevPlayerAndPlayCurPlayer(viewModel: viewModel)
    }

    func presentHidePlayerSlider(with response: PlaybackModels.DisplayPlaybackVideo.Response) {
        let viewModel: Models.DisplayPlaybackVideo.ViewModel = Models.DisplayPlaybackVideo.ViewModel(prevCell: response.prevCell, curCell: nil)
        viewController?.hidePlayerSlider(viewModel: viewModel)
    }

    func presentShowPlayerSlider(with response: PlaybackModels.DisplayPlaybackVideo.Response) {
        let viewModel: Models.DisplayPlaybackVideo.ViewModel = Models.DisplayPlaybackVideo.ViewModel(prevCell: nil, curCell: response.curCell)
        viewController?.showPlayerSlider(viewModel: viewModel)
    }

    func presentTeleportCell(with response: PlaybackModels.DisplayPlaybackVideo.Response) {
        let viewModel: Models.DisplayPlaybackVideo.ViewModel = Models.DisplayPlaybackVideo.ViewModel(indexPathRow: response.indexPathRow, prevCell: nil, curCell: nil)
        viewController?.teleportPlaybackCell(viewModel: viewModel)
    }

    func presentLeavePlaybackView(with response: PlaybackModels.DisplayPlaybackVideo.Response) {
        let viewModel: Models.DisplayPlaybackVideo.ViewModel = Models.DisplayPlaybackVideo.ViewModel(prevCell: response.prevCell, curCell: nil)
        viewController?.leavePlaybackView(viewModel: viewModel)
    }
}
