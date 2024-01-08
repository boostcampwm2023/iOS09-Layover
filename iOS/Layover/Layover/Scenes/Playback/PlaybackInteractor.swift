//
//  PlaybackInteractor.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol PlaybackBusinessLogic {
    func displayVideoList() async
    func moveInitialPlaybackCell()
    func setInitialPlaybackCell()
    func leavePlaybackView()
    func resumePlaybackView()
    func playInitialPlaybackCell(with request: PlaybackModels.DisplayPlaybackVideo.Request)
    func playVideo(with request: PlaybackModels.DisplayPlaybackVideo.Request)
    func playTeleportVideo(with request: PlaybackModels.DisplayPlaybackVideo.Request)
    func playTeleportVideoOnlyOneCell(with request: PlaybackModels.DisplayPlaybackVideo.Request)
    func careVideoLoading(with request: PlaybackModels.DisplayPlaybackVideo.Request)
    func moveVideo(with request: PlaybackModels.DisplayPlaybackVideo.Request)
    func resetVideo()
    func configurePlaybackCell()
    func controlPlaybackMovie(with request: PlaybackModels.SeekVideo.Request)
    func hidePlayerSlider()
    func setSeeMoreButton(with request: PlaybackModels.SetSeemoreButton.Request)
    func deleteVideo(with request: PlaybackModels.DeletePlaybackVideo.Request) async
    func reportVideo(with request: PlaybackModels.ReportPlaybackVideo.Request)
    func resumeVideo()
    func moveToProfile(with request: PlaybackModels.MoveToRelativeView.Request)
    func moveToTagPlay(with request: PlaybackModels.MoveToRelativeView.Request)
    func fetchPosts() async
    func loadProfileImageAndLocation(with request: PlaybackModels.LoadProfileImageAndLocation.Request) async
}

protocol PlaybackDataStore: AnyObject {
    var parentView: PlaybackModels.ParentView? { get set }
    var previousCell: PlaybackCell? { get set }
    var index: Int? { get set }
    var isTeleport: Bool? { get set }
    var isDelete: Bool? { get set }
    var posts: [Post]? { get set }
    var memberID: Int? { get set }
    var boardID: Int? { get set }
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

    var boardID: Int?

    var selectedTag: String?

    private var isFetchReqeust: Bool = false

    private var currentPage: Int = 1

    private var playbackVideoInfos: [Models.PlaybackInfo] = []

    // MARK: - UseCase Load Video List

    func displayVideoList() async {
        guard let parentView: Models.ParentView,
              var posts: [Post],
              let worker: PlaybackWorkerProtocol else { return }
        if parentView == .map {
            posts = worker.makeInfiniteScroll(posts: posts)
            self.posts = posts
        }
        let videos: [Models.PlaybackVideo]
        (videos, playbackVideoInfos) = transPostToVideo(posts)
        let response: Models.LoadPlaybackVideoList.Response = Models.LoadPlaybackVideoList.Response(videos: videos)
        await MainActor.run {
            presenter?.presentVideoList(with: response)
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
        var response: Models.DisplayPlaybackVideo.Response
        if previousCell == request.currentCell {
            response = Models.DisplayPlaybackVideo.Response(previousCell: nil, currentCell: previousCell)
            presenter?.presentShowPlayerSlider(with: response)
            isTeleport = false
            return
        }
        // map에서 왔을 경우(로드한 목록 무한 반복)
        if parentView == .map {
            if request.indexPathRow == (playbackVideoInfos.count - 1) {
                response = Models.DisplayPlaybackVideo.Response(indexPathRow: 1, previousCell: previousCell, currentCell: nil)
            } else if request.indexPathRow == 0 {
                response = Models.DisplayPlaybackVideo.Response(indexPathRow: playbackVideoInfos.count - 2, previousCell: previousCell, currentCell: nil)
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
        var response: Models.DisplayPlaybackVideo.Response
        if let isTeleport, isTeleport == true, (request.indexPathRow == 1 || request.indexPathRow == (playbackVideoInfos.count - 2)) {
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

    func playTeleportVideoOnlyOneCell(with request: PlaybackModels.DisplayPlaybackVideo.Request) {
        if let isTeleport, isTeleport == true, playbackVideoInfos.count == 3 {
            presenter?.presentMoveCellNext(with: Models.DisplayPlaybackVideo.Response(previousCell: previousCell, currentCell: previousCell))
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

    func moveVideo(with request: PlaybackModels.DisplayPlaybackVideo.Request) {
        presenter?.presentTeleportCell(with: Models.DisplayPlaybackVideo.Response(indexPathRow: request.indexPathRow, previousCell: nil, currentCell: nil))
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

    func setSeeMoreButton(with request: PlaybackModels.SetSeemoreButton.Request) {
        guard let worker,
              request.indexPathRow < playbackVideoInfos.count
        else { return }
        memberID = playbackVideoInfos[request.indexPathRow].memberID
        guard let currentCellMemberID = memberID else { return }
        let buttonType: Models.SetSeemoreButton.ButtonType = worker.isMyVideo(currentCellMemberID: currentCellMemberID) ? .delete : .report
        let response: Models.SetSeemoreButton.Response = Models.SetSeemoreButton.Response(buttonType: buttonType, indexPathRow: request.indexPathRow)
        presenter?.presentSetSeemoreButton(with: response)
    }

    // MARK: - UseCase Delete Video

    func deleteVideo(with request: PlaybackModels.DeletePlaybackVideo.Request) async {
        isDelete = true
        guard let worker,
              let parentView,
              request.indexPathRow < playbackVideoInfos.count
        else { return }
        let boardID: Int = playbackVideoInfos[request.indexPathRow].boardID
        let response: Models.DeletePlaybackVideo.Response
        let result = await worker.deletePlaybackVideo(boardID: boardID)
        if parentView == .map {
            // map일 경우 최소 셀 개수가 3개
            if request.indexPathRow == 1 {
                response = Models.DeletePlaybackVideo.Response(
                    result: result,
                    playbackVideo: request.playbackVideo,
                    nextCellIndex: 2,
                    deleteCellIndex: playbackVideoInfos.count - 1,
                    isNeedReplace: false)
                playbackVideoInfos.append(playbackVideoInfos[2])
                if let posts {
                    self.posts?.append((posts[2]))
                }
            } else if request.indexPathRow == playbackVideoInfos.count - 2 {
                response = Models.DeletePlaybackVideo.Response(
                    result: result,
                    playbackVideo: request.playbackVideo,
                    nextCellIndex: request.indexPathRow - 1,
                    deleteCellIndex: 0,
                    isNeedReplace: true)
                playbackVideoInfos.append(playbackVideoInfos[request.indexPathRow - 1])
                if let posts {
                    self.posts?.append((posts[2]))
                }
            } else {
                response = Models.DeletePlaybackVideo.Response(
                    result: result,
                    playbackVideo: request.playbackVideo,
                    nextCellIndex: nil,
                    deleteCellIndex: nil,
                    isNeedReplace: false)
            }
        } else {
            response = Models.DeletePlaybackVideo.Response(
                result: result,
                playbackVideo: request.playbackVideo,
                nextCellIndex: nil,
                deleteCellIndex: nil,
                isNeedReplace: false)
        }
        if result {
            playbackVideoInfos.removeAll { $0.boardID == boardID }
            posts?.removeAll { $0.board.identifier == boardID }
        }
        await MainActor.run {
            presenter?.presentDeleteVideo(with: response)
        }
    }

    func reportVideo(with request: PlaybackModels.ReportPlaybackVideo.Request) {
        if request.indexPathRow < playbackVideoInfos.count { return }
        boardID = playbackVideoInfos[request.indexPathRow].boardID
        presenter?.presentReportVideo()
    }

    func resumeVideo() {
        guard let previousCell else { return }
        previousCell.playbackView.playPlayer()
    }

    private func transPostToVideo(_ posts: [Post]) -> ([Models.PlaybackVideo], [Models.PlaybackInfo]) {
        var videos: [Models.PlaybackVideo] = []
        var infos: [Models.PlaybackInfo] = []
        for post in posts {
            if let videoURL: URL = post.board.videoURL, post.board.status == .complete {
                videos.append(Models.PlaybackVideo(
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
                        tags: post.tag)))
                infos.append(Models.PlaybackInfo(memberID: post.member.identifier, boardID: post.board.identifier))
            }
        }
        return (videos, infos)
    }

    func moveToProfile(with request: PlaybackModels.MoveToRelativeView.Request) {
        guard let indexPathRow = request.indexPathRow, indexPathRow < playbackVideoInfos.count else { return }
        self.memberID = playbackVideoInfos[indexPathRow].memberID
        presenter?.presentProfile()
    }

    func moveToTagPlay(with request: PlaybackModels.MoveToRelativeView.Request) {
        guard let selectedTag = request.selectedTag else { return }
        self.selectedTag = selectedTag
        presenter?.presentTagPlay()
    }

    func fetchPosts() async {
        if !isFetchReqeust {
            isFetchReqeust = true
            var page: Int = 0
            if parentView != .home {
                page = playbackVideoInfos.count / Models.fetchPostCount + 1
                if page == currentPage {
                    return
                }
            }
            currentPage = page
            var newPosts: [Post]?
            switch parentView {
            case .home:
                newPosts = await worker?.fetchHomePosts()
            case .map:
                return
            case .myProfile, .otherProfile:
                newPosts = await worker?.fetchProfilePosts(profileID: memberID, page: page)
            case .tag:
                guard let selectedTag else { return }
                newPosts = await worker?.fetchTagPosts(selectedTag: selectedTag, page: page)
            default:
                return
            }
            guard let newPosts else { return  }
            posts?.append(contentsOf: newPosts)
            let videos: [Models.PlaybackVideo]
            let newInfos: [Models.PlaybackInfo]
            (videos, newInfos) = transPostToVideo(newPosts)
            self.playbackVideoInfos.append(contentsOf: newInfos)
            let response: Models.LoadPlaybackVideoList.Response = Models.LoadPlaybackVideoList.Response(videos: videos)
            await MainActor.run {
                presenter?.presentLoadFetchVideos(with: response)
                isFetchReqeust = false
            }
        }
    }

    func loadProfileImageAndLocation(with request: PlaybackModels.LoadProfileImageAndLocation.Request) async {
        async let profileImageData = self.worker?.fetchImageData(with: request.profileImageURL)
        async let location: String? = self.worker?.transLocation(latitude: request.latitude, longitude: request.longitude)
        let response: Models.LoadProfileImageAndLocation.Response = Models.LoadProfileImageAndLocation.Response(curCell: request.curCell, profileImageData: await profileImageData, location: await location)
        await MainActor.run {
            presenter?.presentLoadProfileImageAndLocation(with: response)
        }
    }
}
