//
//  PlaybackPresenter.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol PlaybackPresentationLogic {
    func presentVideoList(with response: PlaybackModels.LoadPlaybackVideoList.Response)
    func presentSetCellIfInfinite(with response: PlaybackModels.SetInitialPlaybackCell.Response)
    func presentMoveCellNext(with response: PlaybackModels.DisplayPlaybackVideo.Response)
    func presentSetInitialPlaybackCell(with response: PlaybackModels.SetInitialPlaybackCell.Response)
    func presentMoveInitialPlaybackCell(with response: PlaybackModels.SetInitialPlaybackCell.Response)
    func presentPlayInitialPlaybackCell(with response: PlaybackModels.DisplayPlaybackVideo.Response)
    func presentShowPlayerSlider(with response: PlaybackModels.DisplayPlaybackVideo.Response)
    func presentTeleportCell(with response: PlaybackModels.DisplayPlaybackVideo.Response)
    func presentLeavePlaybackView(with response: PlaybackModels.DisplayPlaybackVideo.Response)
    func presentResetPlaybackCell(with response: PlaybackModels.DisplayPlaybackVideo.Response)
    func presentConfigureCell(with response: PlaybackModels.ConfigurePlaybackCell.Response)
    func presentSeekVideo(with response: PlaybackModels.SeekVideo.Response)
    func presentSetSeemoreButton(with response: PlaybackModels.SetSeemoreButton.Response)
    func presentDeleteVideo(with response: PlaybackModels.DeletePlaybackVideo.Response)
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

    func presentSetCellIfInfinite(with response: PlaybackModels.SetInitialPlaybackCell.Response) {
        viewController?.displayMoveCellIfinfinite(viewModel: Models.SetInitialPlaybackCell.ViewModel(indexPathRow: response.indexPathRow))
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
        let viewModel: Models.DisplayPlaybackVideo.ViewModel = Models.DisplayPlaybackVideo.ViewModel(previousCell: response.previousCell, currentCell: response.currentCell)
        viewController?.stopPrevPlayerAndPlayCurPlayer(viewModel: viewModel)
    }

    func presentPlayInitialPlaybackCell(with response: PlaybackModels.DisplayPlaybackVideo.Response) {
        let viewModel: Models.DisplayPlaybackVideo.ViewModel = Models.DisplayPlaybackVideo.ViewModel(previousCell: nil, currentCell: response.currentCell)
        viewController?.stopPrevPlayerAndPlayCurPlayer(viewModel: viewModel)
    }

    func presentShowPlayerSlider(with response: PlaybackModels.DisplayPlaybackVideo.Response) {
        let viewModel: Models.DisplayPlaybackVideo.ViewModel = Models.DisplayPlaybackVideo.ViewModel(previousCell: nil, currentCell: response.currentCell)
        viewController?.showPlayerSlider(viewModel: viewModel)
    }

    func presentTeleportCell(with response: PlaybackModels.DisplayPlaybackVideo.Response) {
        let viewModel: Models.DisplayPlaybackVideo.ViewModel = Models.DisplayPlaybackVideo.ViewModel(indexPathRow: response.indexPathRow, previousCell: nil, currentCell: nil)
        viewController?.teleportPlaybackCell(viewModel: viewModel)
    }

    func presentLeavePlaybackView(with response: PlaybackModels.DisplayPlaybackVideo.Response) {
        let viewModel: Models.DisplayPlaybackVideo.ViewModel = Models.DisplayPlaybackVideo.ViewModel(previousCell: response.previousCell, currentCell: nil)
        viewController?.leavePlaybackView(viewModel: viewModel)
    }

    func presentResetPlaybackCell(with response: PlaybackModels.DisplayPlaybackVideo.Response) {
        let viewModel: Models.DisplayPlaybackVideo.ViewModel = Models.DisplayPlaybackVideo.ViewModel(previousCell: nil, currentCell: response.currentCell)
        viewController?.resetVideo(viewModel: viewModel)
    }

    // MARK: - UseCase Configure Playback Cell

    func presentConfigureCell(with response: PlaybackModels.ConfigurePlaybackCell.Response) {
        let viewModel: Models.ConfigurePlaybackCell.ViewModel = Models.ConfigurePlaybackCell.ViewModel(teleportIndex: response.teleportIndex)
        viewController?.configureDataSource(viewModel: viewModel)
    }

    // MARK: - UseCase Seek Video

    func presentSeekVideo(with response: PlaybackModels.SeekVideo.Response) {
        let viewModel: Models.SeekVideo.ViewModel = Models.SeekVideo.ViewModel(willMoveLocation: response.willMoveLocation, currentCell: response.currentCell)
        viewController?.seekVideo(viewModel: viewModel)
    }

    func presentSetSeemoreButton(with response: PlaybackModels.SetSeemoreButton.Response) {
        let buttonType: Models.SetSeemoreButton.ButtonType = response.parentView == .myProfile ? .delete : .report
        viewController?.setSeemoreButton(viewModel: Models.SetSeemoreButton.ViewModel(buttonType: buttonType))
    }

    func presentDeleteVideo(with response: PlaybackModels.DeletePlaybackVideo.Response) {
        let deleteMessage: Models.DeletePlaybackVideo.DeleteMessage = response.result ? .success : .fail
        let viewModel: Models.DeletePlaybackVideo.ViewModel = Models.DeletePlaybackVideo.ViewModel(deleteMessage: deleteMessage, playbackVideo: response.playbackVideo)
        viewController?.deleteVideo(viewModel: viewModel)
    }
}
