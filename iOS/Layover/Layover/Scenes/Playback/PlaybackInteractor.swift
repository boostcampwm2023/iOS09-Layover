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
    func setInitialPlaybackCell()
    func leavePlaybackView()
    func playInitialPlaybackCell(with request: PlaybackModels.DisplayPlaybackVideo.Request)
    func playVideo(with request: PlaybackModels.DisplayPlaybackVideo.Request)
    func playTeleportVideo(with request: PlaybackModels.DisplayPlaybackVideo.Request)
    func moveToBack()
    func configurePlaybackCell()
    func controlPlaybackMovie(with request: PlaybackModels.SeekVideo.Request)
    func hidePlayerSlider()
}

protocol PlaybackDataStore: AnyObject {
    var parentView: PlaybackModels.ParentView? { get set }
    var prevCell: PlaybackCell? { get set }
    var index: Int? { get set }
    var isTeleport: Bool? { get set }
    var posts: [Post]? { get set }
}

final class PlaybackInteractor: PlaybackBusinessLogic, PlaybackDataStore {

    // MARK: - Properties

    typealias Models = PlaybackModels

    lazy var worker = PlaybackWorker()
    var presenter: PlaybackPresentationLogic?

    var parentView: Models.ParentView?

    var prevCell: PlaybackCell?

    var index: Int?

    var isTeleport: Bool?

    var posts: [Post]?

    // MARK: - UseCase Load Video List

    func displayVideoList() {
        guard let parentView: Models.ParentView else { return }
        guard var posts: [Post] else { return }
        if parentView == .other {
            posts = worker.makeInfiniteScroll(posts: posts)
            self.posts = posts
        }
        let response: Models.LoadPlaybackVideoList.Response = Models.LoadPlaybackVideoList.Response(posts: posts)
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

    func setInitialPlaybackCell() {
        guard let parentView,
              let index else { return }
        let response: Models.SetInitialPlaybackCell.Response
        switch parentView {
        case .home:
            response = Models.SetInitialPlaybackCell.Response(indexPathRow: index)
        case .other:
            response = Models.SetInitialPlaybackCell.Response(indexPathRow: index + 1)
        }
        presenter?.presentSetInitialPlaybackCell(with: response)
    }

    // MARK: - UseCase Playback Video

    func playInitialPlaybackCell(with request: PlaybackModels.DisplayPlaybackVideo.Request) {
        prevCell = request.curCell
        let response: Models.DisplayPlaybackVideo.Response = Models.DisplayPlaybackVideo.Response(prevCell: nil, curCell: request.curCell)
        presenter?.presentPlayInitialPlaybackCell(with: response)
    }

    func playVideo(with request: PlaybackModels.DisplayPlaybackVideo.Request) {
        guard let posts else { return }
        var response: Models.DisplayPlaybackVideo.Response
        if prevCell == request.curCell {
            response = Models.DisplayPlaybackVideo.Response(prevCell: nil, curCell: prevCell)
            presenter?.presentShowPlayerSlider(with: response)
            isTeleport = false
            return
        }
        // Home이 아닌 다른 뷰에서 왔을 경우(로드한 목록 무한 반복)
        if parentView == .other {
            if request.indexPathRow == (posts.count - 1) {
                response = Models.DisplayPlaybackVideo.Response(indexPathRow: 1, prevCell: prevCell, curCell: nil)
            } else if request.indexPathRow == 0 {
                response = Models.DisplayPlaybackVideo.Response(indexPathRow: posts.count - 2, prevCell: prevCell, curCell: nil)
            } else {
                response = Models.DisplayPlaybackVideo.Response(prevCell: prevCell, curCell: request.curCell)
                prevCell = request.curCell
                presenter?.presentMoveCellNext(with: response)
                isTeleport = false
                return
            }
            isTeleport = true
            presenter?.presentTeleportCell(with: response)
            return
        }
        // Home이면 다음 셀로 이동(추가적인 비디오 로드)
        isTeleport = false
        response = Models.DisplayPlaybackVideo.Response(prevCell: prevCell, curCell: request.curCell)
        prevCell = request.curCell
        presenter?.presentMoveCellNext(with: response)
    }

    func playTeleportVideo(with request: PlaybackModels.DisplayPlaybackVideo.Request) {
        guard let isTeleport,
              let posts else { return }
        if isTeleport {
            if request.indexPathRow == 1 || request.indexPathRow == (posts.count - 2) {
                let response: Models.DisplayPlaybackVideo.Response = Models.DisplayPlaybackVideo.Response(prevCell: prevCell, curCell: request.curCell)
                prevCell = request.curCell
                presenter?.presentMoveCellNext(with: response)
                self.isTeleport = false
            }
        }
    }

    func leavePlaybackView() {
        let response: Models.DisplayPlaybackVideo.Response = Models.DisplayPlaybackVideo.Response(prevCell: prevCell, curCell: nil)
        presenter?.presentLeavePlaybackView(with: response)
    }

    func moveToBack() {
        let response: Models.DisplayPlaybackVideo.Response = Models.DisplayPlaybackVideo.Response(prevCell: nil, curCell: prevCell)
        presenter?.presentResetPlaybackCell(with: response)
    }

    func configurePlaybackCell() {
        guard let posts,
              let parentView else { return }
        let response: Models.ConfigurePlaybackCell.Response
        switch parentView {
        case .home:
            response = Models.ConfigurePlaybackCell.Response(teleportIndex: nil)
        case .other:
            response = Models.ConfigurePlaybackCell.Response(teleportIndex: posts.count + 1)
        }
        presenter?.presentConfigureCell(with: response)
    }

    func controlPlaybackMovie(with request: PlaybackModels.SeekVideo.Request) {
        guard let prevCell,
              let playbackView = prevCell.playbackView
        else { return }
        let willMoveLocation: Float64 = request.currentLocation * playbackView.getDuration()
        let response: Models.SeekVideo.Response = Models.SeekVideo.Response(willMoveLocation: willMoveLocation, curCell: prevCell)
        presenter?.presentSeekVideo(with: response)
    }

    func hidePlayerSlider() {
        guard let prevCell else { return }
        prevCell.playbackView?.playerSlider?.isHidden = true
    }
}
