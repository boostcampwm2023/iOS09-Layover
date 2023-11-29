//
//  PlaybackInteractor.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol PlaybackBusinessLogic {
    func displayVideoList()
    func moveInitialPlaybackCell()
    func hidePlayerSlider()
    func moveCellIfInfinite(with request: PlaybackModels.DisplayPlaybackVideo.Request)
    func setInitialPlaybackCell()
    func playInitialPlaybackCell(with request: PlaybackModels.DisplayPlaybackVideo.Request)
    func playVideo(with request: PlaybackModels.DisplayPlaybackVideo.Request)
}

protocol PlaybackDataStore: AnyObject {
    var videos: [PlaybackModels.Board]? { get set }
    var parentView: PlaybackModels.ParentView? { get set }
    var prevCell: PlaybackCell? { get set }
    var index: Int? { get set }
}

final class PlaybackInteractor: PlaybackBusinessLogic, PlaybackDataStore {

    // MARK: - Properties

    typealias Models = PlaybackModels

    lazy var worker = PlaybackWorker()
    var presenter: PlaybackPresentationLogic?
    var videos: [Models.Board]?
    var parentView: Models.ParentView?
    var prevCell: PlaybackCell?
    var index: Int?

    func displayVideoList() {
        guard let parentView: Models.ParentView else {
            return
        }
        guard var videos: [PlaybackModels.Board] else {
            return
        }
        if parentView == .other {
            videos = worker.makeInfiniteScroll(videos: videos)
        }
        let response: Models.LoadPlaybackVideoList.Response = Models.LoadPlaybackVideoList.Response(videos: videos)
        presenter?.presentVideoList(with: response)
    }

    func moveInitialPlaybackCell() {
        let response: Models.SetInitialPlaybackCell.Response = Models.SetInitialPlaybackCell.Response(indexPathRow: index ?? 0)
        if parentView == .other {
            presenter?.presentSetCellIfInfinite()
        } else {
            presenter?.presentMoveInitialPlaybackCell(with: response)
        }
    }

    func moveCellIfInfinite(with request: PlaybackModels.DisplayPlaybackVideo.Request) {
    }

    func setInitialPlaybackCell() {
        guard let parentView else { return }
        guard let index else { return }
        let response: Models.SetInitialPlaybackCell.Response
        switch parentView {
        case .home:
            response = Models.SetInitialPlaybackCell.Response(indexPathRow: index)
        case .other:
            response = Models.SetInitialPlaybackCell.Response(indexPathRow: index + 1)
        }
        presenter?.presentSetInitialPlaybackCell(with: response)
    }

    func playInitialPlaybackCell(with request: PlaybackModels.DisplayPlaybackVideo.Request) {
        prevCell = request.curCell
        let response: Models.DisplayPlaybackVideo.Response = Models.DisplayPlaybackVideo.Response(prevCell: nil, curCell: request.curCell)
        presenter?.presentPlayInitialPlaybackCell(with: response)
    }

    func hidePlayerSlider() {
        let response: Models.DisplayPlaybackVideo.Response = Models.DisplayPlaybackVideo.Response(prevCell: prevCell, curCell: nil)
        presenter?.presentHidePlayerSlider(with: response)
    }

    func playVideo(with request: PlaybackModels.DisplayPlaybackVideo.Request) {
        var response: Models.DisplayPlaybackVideo.Response
        if prevCell == request.curCell {
            response = Models.DisplayPlaybackVideo.Response(prevCell: nil, curCell: prevCell)
            presenter?.presentShowPlayerSlider(with: response)
            return
        }
        if parentView == .other {
            // TelePort
            // 특정 조건 때 다른 Present call
            return
        }
        response = Models.DisplayPlaybackVideo.Response(prevCell: prevCell, curCell: request.curCell)
        prevCell = request.curCell
        presenter?.presentMoveCellNext(with: response)
    }
}
