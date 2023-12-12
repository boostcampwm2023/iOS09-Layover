//
//  PlaybackInteractor.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol PlaybackBusinessLogic {
    @discardableResult
    func displayVideoList() -> Task<Bool, Never>
    func moveInitialPlaybackCell()
    func setInitialPlaybackCell()
    func leavePlaybackView()
    func resumePlaybackView()
    func playInitialPlaybackCell(with request: PlaybackModels.DisplayPlaybackVideo.Request)
    func playVideo(with request: PlaybackModels.DisplayPlaybackVideo.Request)
    func playTeleportVideo(with request: PlaybackModels.DisplayPlaybackVideo.Request)
    func careVideoLoading(with request: PlaybackModels.DisplayPlaybackVideo.Request)
    func resetVideo()
    func configurePlaybackCell()
    func controlPlaybackMovie(with request: PlaybackModels.SeekVideo.Request)
    func hidePlayerSlider()
    func setSeeMoreButton()
    @discardableResult
    func deleteVideo(with request: PlaybackModels.DeletePlaybackVideo.Request) -> Task<Bool, Never>
    func resumeVideo()
    func moveToProfile(with request: PlaybackModels.MoveToRelativeView.Request)
    func moveToTagPlay(with request: PlaybackModels.MoveToRelativeView.Request)
    @discardableResult
    func fetchPosts() -> Task<Bool, Never>
    @discardableResult
    func loadProfileImageAndLocation(with request: PlaybackModels.LoadProfileImageAndLocation.Request) -> Task<Bool, Never>
}

protocol PlaybackDataStore: AnyObject {
    var parentView: PlaybackModels.ParentView? { get set }
    var previousCell: PlaybackCell? { get set }
    var index: Int? { get set }
    var isTeleport: Bool? { get set }
    var isDelete: Bool? { get set }
    var posts: [Post]? { get set }
    var memberID: Int? { get set }
    var selectedTag: String? { get set }
}

final class PlaybackInteractor: PlaybackBusinessLogic, PlaybackDataStore {

    // MARK: - Properties

    typealias Models = PlaybackModels

    var worker: PlaybackWorkerProtocol?
    var presenter: PlaybackPresentationLogic?

    var parentView: Models.ParentView?

    var previousCell: PlaybackCell?

    var index: Int?

    var isTeleport: Bool?

    var isDelete: Bool?

    var posts: [Post]?

    var memberID: Int?

    var selectedTag: String?

    private var isFetchReqeust: Bool = false

    private var currentPage: Int = 1

    // MARK: - UseCase Load Video List

    func displayVideoList() -> Task<Bool, Never> {
        Task {
            guard let parentView: Models.ParentView,
                  var posts: [Post],
                  let worker: PlaybackWorkerProtocol else { return false }
            if parentView == .map {
                posts = worker.makeInfiniteScroll(posts: posts)
                self.posts = posts
            }
            let videos: [Models.PlaybackVideo] = transPostToVideo(posts)
            let response: Models.LoadPlaybackVideoList.Response = Models.LoadPlaybackVideoList.Response(videos: videos)
            await MainActor.run {
                presenter?.presentVideoList(with: response)
            }
            return true
        }
    }

    func moveInitialPlaybackCell() {
        guard let parentView,
              let index
        else { return }
        let willMoveIndex: Int
        willMoveIndex = parentView == .map ? index + 1 : index
        presenter?.presentMoveInitialPlaybackCell(with: Models.SetInitialPlaybackCell.Response(indexPathRow: willMoveIndex))
    }

    func setInitialPlaybackCell() {
        guard let parentView,
              let index else { return }
        let willMoveIndex: Int
        willMoveIndex = parentView == .map ? index + 1 : index
        let response: Models.SetInitialPlaybackCell.Response = Models.SetInitialPlaybackCell.Response(indexPathRow: willMoveIndex)
        presenter?.presentSetInitialPlaybackCell(with: response)
    }

    // MARK: - UseCase Playback Video

    func playInitialPlaybackCell(with request: PlaybackModels.DisplayPlaybackVideo.Request) {
        previousCell = request.currentCell
        let response: Models.DisplayPlaybackVideo.Response = Models.DisplayPlaybackVideo.Response(previousCell: nil, currentCell: request.currentCell)
        presenter?.presentPlayInitialPlaybackCell(with: response)
    }

    func playVideo(with request: PlaybackModels.DisplayPlaybackVideo.Request) {
        guard let posts else { return }
        var response: Models.DisplayPlaybackVideo.Response
        if previousCell == request.currentCell {
            response = Models.DisplayPlaybackVideo.Response(previousCell: nil, currentCell: previousCell)
            presenter?.presentShowPlayerSlider(with: response)
            isTeleport = false
            return
        }
        // map에서 왔을 경우(로드한 목록 무한 반복)
        if parentView == .map {
            if request.indexPathRow == (posts.count - 1) {
                response = Models.DisplayPlaybackVideo.Response(indexPathRow: 1, previousCell: previousCell, currentCell: nil)
            } else if request.indexPathRow == 0 {
                response = Models.DisplayPlaybackVideo.Response(indexPathRow: posts.count - 2, previousCell: previousCell, currentCell: nil)
            } else {
                response = Models.DisplayPlaybackVideo.Response(previousCell: previousCell, currentCell: request.currentCell)
                previousCell = request.currentCell
                presenter?.presentMoveCellNext(with: response)
                isTeleport = false
                return
            }
            isTeleport = true
            presenter?.presentTeleportCell(with: response)
            return
        }
        // map이 아니면 다음 셀로 이동(추가적인 비디오 로드)
        isTeleport = false
        response = Models.DisplayPlaybackVideo.Response(previousCell: previousCell, currentCell: request.currentCell)
        previousCell = request.currentCell
        presenter?.presentMoveCellNext(with: response)
    }

    func playTeleportVideo(with request: PlaybackModels.DisplayPlaybackVideo.Request) {
        guard let posts else { return }
        var response: Models.DisplayPlaybackVideo.Response
        if let isTeleport, isTeleport == true, (request.indexPathRow == 1 || request.indexPathRow == (posts.count - 2)) {
                response = Models.DisplayPlaybackVideo.Response(previousCell: previousCell, currentCell: request.currentCell)
            previousCell = request.currentCell
                presenter?.presentMoveCellNext(with: response)
                self.isTeleport = false
            }

        if let isDelete, isDelete == true {
            response = Models.DisplayPlaybackVideo.Response(previousCell: nil, currentCell: request.currentCell)
            previousCell = request.currentCell
            presenter?.presentMoveCellNext(with: response)
            self.isDelete = false
        }
    }

    func resumePlaybackView() {
        if let previousCell {
            let response: Models.DisplayPlaybackVideo.Response = Models.DisplayPlaybackVideo.Response(previousCell: nil, currentCell: previousCell)
            presenter?.presentPlayInitialPlaybackCell(with: response)
        } else {
            guard let index else { return }
            let response: Models.SetInitialPlaybackCell.Response = Models.SetInitialPlaybackCell.Response(indexPathRow: index)
            presenter?.presentSetInitialPlaybackCell(with: response)
        }
    }

    func leavePlaybackView() {
        let response: Models.DisplayPlaybackVideo.Response = Models.DisplayPlaybackVideo.Response(previousCell: previousCell, currentCell: nil)
        presenter?.presentLeavePlaybackView(with: response)
    }

    func resetVideo() {
        let response: Models.DisplayPlaybackVideo.Response = Models.DisplayPlaybackVideo.Response(previousCell: nil, currentCell: previousCell)
        presenter?.presentResetPlaybackCell(with: response)
    }

    func careVideoLoading(with request: PlaybackModels.DisplayPlaybackVideo.Request) {
        if previousCell == nil {
            previousCell = request.currentCell
            let response: Models.DisplayPlaybackVideo.Response = Models.DisplayPlaybackVideo.Response(previousCell: nil, currentCell: previousCell)
            presenter?.presentMoveCellNext(with: response)
        }
    }

    // MARK: - UseCase ConfigureCell

    func configurePlaybackCell() {
        guard let posts,
              let parentView else { return }
        let willMoveTeleportIndex: Int?
        willMoveTeleportIndex = parentView == .map ? posts.count + 1 : nil
        let response: Models.ConfigurePlaybackCell.Response = Models.ConfigurePlaybackCell.Response(teleportIndex: willMoveTeleportIndex)
        presenter?.presentConfigureCell(with: response)
    }

    func controlPlaybackMovie(with request: PlaybackModels.SeekVideo.Request) {
        guard let previousCell else { return }
        let willMoveLocation: Float64 = request.currentLocation * previousCell.playbackView.getDuration()
        let response: Models.SeekVideo.Response = Models.SeekVideo.Response(willMoveLocation: willMoveLocation, currentCell: previousCell)
        presenter?.presentSeekVideo(with: response)
    }

    func hidePlayerSlider() {
        guard let previousCell else { return }
        previousCell.playbackView.playerSlider?.isHidden = true
    }

    func setSeeMoreButton() {
        guard let worker,
              let currentCellMemberID: Int = previousCell?.memberID
        else { return }
        let buttonType: Models.SetSeemoreButton.ButtonType = worker.isMyVideo(currentCellMemberID: currentCellMemberID) ? .delete : .report
        let response: Models.SetSeemoreButton.Response = Models.SetSeemoreButton.Response(buttonType: buttonType)
        presenter?.presentSetSeemoreButton(with: response)
    }

    // MARK: - UseCase Delete Video

    func deleteVideo(with request: PlaybackModels.DeletePlaybackVideo.Request) -> Task<Bool, Never> {
        isDelete = true
        guard let previousCell,
              let worker
        else { return Task { false } }
        guard let boardID = previousCell.boardID else { return Task { false } }
        return Task {
            let result: Bool = await worker.deletePlaybackVideo(boardID: boardID)
            let response: Models.DeletePlaybackVideo.Response = Models.DeletePlaybackVideo.Response(result: result, playbackVideo: request.playbackVideo)
            await MainActor.run {
                presenter?.presentDeleteVideo(with: response)
            }
            return result
        }
    }

    func resumeVideo() {
        guard let previousCell else { return }
        previousCell.playbackView.playPlayer()
    }

    private func transPostToVideo(_ posts: [Post]) -> [Models.PlaybackVideo] {
        return posts.compactMap { post in
            guard let videoURL: URL = post.board.videoURL else { return nil }
            return Models.PlaybackVideo(
                displayedPost: Models.DisplayedPost(
                    member: Models.Member(
                        memberID: post.member.identifier,
                        username: post.member.username,
                        profileImageURL: post.member.profileImageURL),
                    board: Models.Board(
                        boardID: post.board.identifier,
                        title: post.board.title,
                        description: post.board.description,
                        videoURL: videoURL,
                        latitude: post.board.latitude,
                        longitude: post.board.longitude),
                    tags: post.tag))
        }
    }

    func moveToProfile(with request: PlaybackModels.MoveToRelativeView.Request) {
        guard let memberID = request.memberID else { return }
        self.memberID = memberID
        presenter?.presentProfile()
    }

    func moveToTagPlay(with request: PlaybackModels.MoveToRelativeView.Request) {
        guard let selectedTag = request.selectedTag else { return }
        self.selectedTag = selectedTag
        presenter?.presentTagPlay()
    }

    func fetchPosts() -> Task<Bool, Never> {
        Task {
            if !isFetchReqeust {
                isFetchReqeust = true
                var page: Int = 0
                if parentView != .home {
                    guard let posts else { return false }
                    page = posts.count / 15 + 1
                    if page == currentPage {
                        return false
                    }
                }
                currentPage = page
                var newPosts: [Post]?
                switch parentView {
                case .home:
                    newPosts = await worker?.fetchHomePosts()
                case .map:
                    return false
                case .myProfile, .otherProfile:
                    newPosts = await worker?.fetchProfilePosts(profileID: memberID, page: page)
                case .tag:
                    guard let selectedTag else { return false }
                    newPosts = await worker?.fetchTagPosts(selectedTag: selectedTag, page: page)
                default:
                    return false
                }
                guard let newPosts else { return false }
                self.posts?.append(contentsOf: newPosts)
                let videos: [Models.PlaybackVideo] = transPostToVideo(newPosts)
                let response: Models.LoadPlaybackVideoList.Response = Models.LoadPlaybackVideoList.Response(videos: videos)
                await MainActor.run {
                    presenter?.presentLoadFetchVideos(with: response)
                    isFetchReqeust = false
                }
                return true
            }
            return false
        }
    }

    func loadProfileImageAndLocation(with request: PlaybackModels.LoadProfileImageAndLocation.Request) -> Task<Bool, Never> {
        Task {
            async let profileImageData = self.worker?.fetchImageData(with: request.profileImageURL)
            async let location: String? = self.worker?.transLocation(latitude: request.latitude, longitude: request.longitude)
            let response: Models.LoadProfileImageAndLocation.Response = Models.LoadProfileImageAndLocation.Response(curCell: request.curCell, profileImageData: await profileImageData, location: await location)
            await MainActor.run {
                presenter?.presentLoadProfileImageAndLocation(with: response)
                return true
            }
            return false
        }
    }
}
