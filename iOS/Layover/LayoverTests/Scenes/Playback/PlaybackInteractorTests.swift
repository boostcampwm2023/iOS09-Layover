//
//  PlaybackInteractorTests.swift
//  LayoverTests
//
//  Created by 황지웅 on 12/12/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

@testable import Layover
import XCTest

final class PlaybackInteractorTests: XCTestCase {
    // MARK: Subject under test

    var sut: PlaybackInteractor!

    // MARK: Properties

    typealias Models = PlaybackModels

    // MARK: - Test lifecycle

    override func setUp() {
        super.setUp()
        setupPlaybackInteracotr()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Test setup

    func setupPlaybackInteracotr() {
        sut = PlaybackInteractor()
        sut.worker = MockPlaybackWorker()
    }

    // MARK: - Test doubles

    final class PlaybackPresentationLogicSpy: PlaybackPresentationLogic {
        var presentVideoListDidCalled = false
        var presentVideoListResponse: Models.LoadPlaybackVideoList.Response!

        var presentLoadFetchVideosDidCalled = false
        var presentLoadFetchVideosResponse: Models.LoadPlaybackVideoList.Response!

        var presentSetInitialPlaybackCellDidCalled = false
        var presentSetInitialPlaybackCellResponse: Models.SetInitialPlaybackCell.Response!

        var presentMoveInitialPlaybackCellDidCalled = false
        var presentMoveInitialPlaybackCellResponse: Models.SetInitialPlaybackCell.Response!

        var presentMoveCellNextDidCalled = false
        var presentMoveCellNextResponse: Models.DisplayPlaybackVideo.Response!

        var presentPlayInitialPlaybackCellDidCalled = false
        var presentPlayInitialPlaybackCellResponse: Models.DisplayPlaybackVideo.Response!

        var presentShowPlayerSliderDidCalled = false
        var presentShowPlayerSliderResponse: Models.DisplayPlaybackVideo.Response!

        var presentTeleportCellDidCalled = false
        var presentTeleportCellResponse: Models.DisplayPlaybackVideo.Response!

        var presentLeavePlaybackViewDidCalled = false
        var presentLeavePlaybackViewResponse: Models.DisplayPlaybackVideo.Response!

        var presentResetPlaybackCellDidCalled = false
        var presentResetPlaybackCellResponse: Models.DisplayPlaybackVideo.Response!

        var presentConfigureCellDidCalled = false
        var presentConfigureCellResponse: Models.ConfigurePlaybackCell.Response!

        var presentSetSeemoreButtonDidCalled = false
        var presentSetSeemoreButtonResponse: Models.SetSeemoreButton.Response!

        var presentDeleteVideoDidCalled = false
        var presentDeleteVideoResponse: Models.DeletePlaybackVideo.Response!

        var presentProfileDidCalled = false

        var presentTagPlayDidCalled = false

        var presentLoadProfileImageAndLocationDidCalled = false
        var presentLoadProfileImageAndLocationResponse: Models.LoadProfileImageAndLocation.Response!

        func presentVideoList(with response: Layover.PlaybackModels.LoadPlaybackVideoList.Response) {
            presentVideoListDidCalled = true
            presentVideoListResponse = response
        }
        
        func presentLoadFetchVideos(with response: Layover.PlaybackModels.LoadPlaybackVideoList.Response) {
            presentLoadFetchVideosDidCalled = true
            presentLoadFetchVideosResponse = response
        }
        
        func presentSetInitialPlaybackCell(with response: Layover.PlaybackModels.SetInitialPlaybackCell.Response) {
            presentSetInitialPlaybackCellDidCalled = true
            presentSetInitialPlaybackCellResponse = response
        }
        
        func presentMoveInitialPlaybackCell(with response: Layover.PlaybackModels.SetInitialPlaybackCell.Response) {
            presentMoveInitialPlaybackCellDidCalled = true
            presentMoveInitialPlaybackCellResponse = response
        }
        
        func presentMoveCellNext(with response: Layover.PlaybackModels.DisplayPlaybackVideo.Response) {
            presentMoveCellNextDidCalled = true
            presentMoveCellNextResponse = response
        }
        
        func presentPlayInitialPlaybackCell(with response: Layover.PlaybackModels.DisplayPlaybackVideo.Response) {
            presentPlayInitialPlaybackCellDidCalled = true
            presentPlayInitialPlaybackCellResponse = response
        }

        func presentShowPlayerSlider(with response: Layover.PlaybackModels.DisplayPlaybackVideo.Response) {
            presentShowPlayerSliderDidCalled = true
            presentShowPlayerSliderResponse = response
        }
        
        func presentTeleportCell(with response: Layover.PlaybackModels.DisplayPlaybackVideo.Response) {
            presentTeleportCellDidCalled = true
            presentTeleportCellResponse = response
        }
        
        func presentLeavePlaybackView(with response: Layover.PlaybackModels.DisplayPlaybackVideo.Response) {
            presentLeavePlaybackViewDidCalled = true
            presentLeavePlaybackViewResponse = response
        }
        
        func presentResetPlaybackCell(with response: Layover.PlaybackModels.DisplayPlaybackVideo.Response) {
            presentResetPlaybackCellDidCalled = true
            presentResetPlaybackCellResponse = response
        }
        
        func presentConfigureCell(with response: Layover.PlaybackModels.ConfigurePlaybackCell.Response) {
            presentConfigureCellDidCalled = true
            presentConfigureCellResponse = response
        }
        
        func presentSetSeemoreButton(with response: Layover.PlaybackModels.SetSeemoreButton.Response) {
            presentSetSeemoreButtonDidCalled = true
            presentSetSeemoreButtonResponse = response
        }
        
        func presentDeleteVideo(with response: Layover.PlaybackModels.DeletePlaybackVideo.Response) {
            presentDeleteVideoDidCalled = true
            presentDeleteVideoResponse = response
        }
        
        func presentProfile() {
            presentProfileDidCalled = true
        }
        
        func presentTagPlay() {
            presentTagPlayDidCalled = true
        }
        
        func presentLoadProfileImageAndLocation(with response: Layover.PlaybackModels.LoadProfileImageAndLocation.Response) {
            presentLoadProfileImageAndLocationDidCalled = true
            presentLoadProfileImageAndLocationResponse = response
        }
    }

    // MARK: - Tests

    func test_displayVideoList를_호출하면_presentVideoList를_호출하고_올바른_데이터를_전달한다_parentView가_map일_때() async {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.presenter = spy
        sut.parentView = .map
        sut.posts = [Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.videoURLNilPost]

        // Act
        let result = await sut.displayVideoList().value

        // Assert
        XCTAssertTrue(spy.presentVideoListDidCalled, "displayVideoList는 presentVideoList를 호출하지 않았습니다")
        XCTAssertTrue(result, "displayVideoList는 동작에 실패했습니다")
        // map이므로 2 + 더미셀 2 = 4
        // videoURL이 nil이면 거름
        XCTAssertEqual(spy.presentVideoListResponse.videos.count, 4)
        XCTAssertEqual(spy.presentVideoListResponse.videos[0].displayedPost, spy.presentVideoListResponse.videos[2].displayedPost)
        XCTAssertEqual(spy.presentVideoListResponse.videos[1].displayedPost, spy.presentVideoListResponse.videos[1].displayedPost)
        XCTAssertEqual(spy.presentVideoListResponse.videos.first!.displayedPost, Seeds.PlaybackVideos.videos.last!.displayedPost)
        XCTAssertEqual(spy.presentVideoListResponse.videos.last!.displayedPost, Seeds.PlaybackVideos.videos.first!.displayedPost)
    }

    func test_displayVideoList를_호출하면_presentVideoList를_호출하고_올바른_데이터를_전달한다_parentView가_map이_아닐때() async {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.presenter = spy
        sut.parentView = .home
        sut.posts = [Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.videoURLNilPost]

        // Act
        let result = await sut.displayVideoList().value

        // Assert
        XCTAssertTrue(spy.presentVideoListDidCalled, "displayVideoList는 presentVideoList를 호출하지 않았습니다")
        XCTAssertTrue(result, "displayVideoList는 동작에 성공했습니다")
        // map이므로 2 + 더미셀 2 = 4
        // videoURL이 nil이면 거름
        XCTAssertEqual(spy.presentVideoListResponse.videos.count, 2)
        XCTAssertEqual(spy.presentVideoListResponse.videos.first!.displayedPost, Seeds.PlaybackVideos.videos.first!.displayedPost)
        XCTAssertEqual(spy.presentVideoListResponse.videos.last!.displayedPost, Seeds.PlaybackVideos.videos.last!.displayedPost)
    }

    func test_moveInitialPlaybackCell을_호출하면_presentMoveInitialPlaybackCell을_호출하고_올바른_데이터를_전달한다_parentView가_map일_때() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.parentView = .map
        sut.index = 2
        sut.presenter = spy

        // Act
        sut.moveInitialPlaybackCell()

        // Assert
        XCTAssertTrue(spy.presentMoveInitialPlaybackCellDidCalled, "moveInitialPlaybackCell은 moveInitialPlaybackCell을 호출하지 않았습니다")
        XCTAssertEqual(spy.presentMoveInitialPlaybackCellResponse.indexPathRow, 3)
    }

    func test_moveInitialPlaybackCell을_호출하면_presentMoveInitialPlaybackCell을_호출하고_올바른_데이터를_전달한다_parentView가_map이_아닐때() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.parentView = .home
        sut.index = 2
        sut.presenter = spy

        // Act
        sut.moveInitialPlaybackCell()

        // Assert
        XCTAssertTrue(spy.presentMoveInitialPlaybackCellDidCalled, "moveInitialPlaybackCell은 moveInitialPlaybackCell을 호출하지 않았습니다")
        XCTAssertEqual(spy.presentMoveInitialPlaybackCellResponse.indexPathRow, 2)
    }

    func test_setInitialPlaybackCell을_호출하면_presentSetInitialPlaybackCell을_호출하고_올바른_데이터를_전달한다_parentView가_map일_때() {
        // Arraynge
        let spy = PlaybackPresentationLogicSpy()
        sut.parentView = .map
        sut.index = 2
        sut.presenter = spy

        // Act
        sut.setInitialPlaybackCell()

        // Assert
        XCTAssertTrue(spy.presentSetInitialPlaybackCellDidCalled, "setInitialPlaybackCell은 presentSetInitialPlaybackCell을 호출하지 않았습니다.")
        XCTAssertEqual(spy.presentSetInitialPlaybackCellResponse.indexPathRow, 3)
    }

    func test_setInitialPlaybackCell을_호출하면_presentSetInitialPlaybackCell을_호출하고_올바른_데이터를_전달한다_parentView가_map이_아닐때() {
        // Arraynge
        let spy = PlaybackPresentationLogicSpy()
        sut.parentView = .map
        sut.index = 2
        sut.presenter = spy

        // Act
        sut.setInitialPlaybackCell()

        // Assert
        XCTAssertTrue(spy.presentSetInitialPlaybackCellDidCalled, "setInitialPlaybackCell은 presentSetInitialPlaybackCell을 호출하지 않았습니다")
        XCTAssertEqual(spy.presentSetInitialPlaybackCellResponse.indexPathRow, 3)
    }

    func test_playInitialPlaybackCell을_호출하면_presentPlayInitialPlaybackCell을_호출하고_올바른_데이터를_전달한다() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        let request: Models.DisplayPlaybackVideo.Request = Models.DisplayPlaybackVideo.Request(indexPathRow: nil, currentCell: Seeds.PlaybackVideo.currentCell)
        sut.presenter = spy
        // Act
        sut.playInitialPlaybackCell(with: request)

        // Assert
        XCTAssertTrue(spy.presentPlayInitialPlaybackCellDidCalled, "playInitialPlaybackCell은 presentInitialPlaybackCell을 호출하지 않았습니다")
        XCTAssertEqual(spy.presentPlayInitialPlaybackCellResponse.previousCell, nil)
        XCTAssertEqual(spy.presentPlayInitialPlaybackCellResponse.currentCell, sut.previousCell)
        XCTAssertEqual(spy.presentPlayInitialPlaybackCellResponse.currentCell, Seeds.PlaybackVideo.currentCell)
    }

    func test_playVideo를_호출할_때_이전Cell과_현재Cell이_동일하면_presentShowPlayerSlider를_호출한다() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.posts = [Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.videoURLNilPost]
        sut.previousCell = Seeds.PlaybackVideo.currentCell
        let request: Models.DisplayPlaybackVideo.Request = Models.DisplayPlaybackVideo.Request(indexPathRow: nil, currentCell: Seeds.PlaybackVideo.currentCell)
        sut.presenter = spy
        // Act
        sut.playVideo(with: request)

        // Assert
        XCTAssertTrue(spy.presentShowPlayerSliderDidCalled, "playVideo는 presentShowPlayerSlider를 호출하지 않았습니다")
        XCTAssertEqual(spy.presentShowPlayerSliderResponse.currentCell, request.currentCell)
    }

    func test_playVideo를_호출하면_presentMoveCellNext를_호출한다_parentView가_map이고_index가_마지막을_가리킬_떄() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.parentView = .map
        sut.posts = [Seeds.Posts.post1, Seeds.Posts.post2]
        sut.previousCell = Seeds.PlaybackVideo.previousCell
        let request: Models.DisplayPlaybackVideo.Request = Models.DisplayPlaybackVideo.Request(indexPathRow: 1, currentCell: Seeds.PlaybackVideo.currentCell)
        sut.presenter = spy
        // act
        sut.playVideo(with: request)

        // Assert
        XCTAssertTrue(spy.presentTeleportCellDidCalled, "playVideo는 presentTeleportCell를 호출하지 않았습니다")
        XCTAssertEqual(sut.previousCell, Seeds.PlaybackVideo.previousCell)
        XCTAssertEqual(spy.presentTeleportCellResponse.previousCell, Seeds.PlaybackVideo.previousCell)
        XCTAssertEqual(spy.presentTeleportCellResponse.indexPathRow, 1)
        XCTAssertTrue(((sut.isTeleport) != nil))
    }

    func test_playVideo를_호출하면_presentMoveCellNext를_호출한다_parentView가_map이고_index가_처음을_가리킬_떄() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.parentView = .map
        sut.posts = [Seeds.Posts.post1, Seeds.Posts.post2]
        sut.previousCell = Seeds.PlaybackVideo.previousCell
        let request: Models.DisplayPlaybackVideo.Request = Models.DisplayPlaybackVideo.Request(indexPathRow: 0, currentCell: Seeds.PlaybackVideo.currentCell)
        sut.presenter = spy
        // act
        sut.playVideo(with: request)

        // Assert
        XCTAssertTrue(spy.presentTeleportCellDidCalled, "playVideo는 presentTeleportCell를 호출하지 않았습니다")
        XCTAssertEqual(spy.presentTeleportCellResponse.previousCell, Seeds.PlaybackVideo.previousCell)
        XCTAssertEqual(spy.presentTeleportCellResponse.currentCell, nil)
        XCTAssertEqual(spy.presentTeleportCellResponse.indexPathRow, 0)
        XCTAssertTrue(((sut.isTeleport) != nil))
    }

    func test_playVideo를_호출하면_presentMoveCellNext를_호출한다_parentView가_map이고_텔레포트가_필요없는_상황일_때() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.parentView = .map
        sut.previousCell = Seeds.PlaybackVideo.previousCell
        sut.posts = [Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.thumbnailImageNilPost]
        sut.previousCell = Seeds.PlaybackVideo.previousCell
        let request: Models.DisplayPlaybackVideo.Request = Models.DisplayPlaybackVideo.Request(indexPathRow: 1, currentCell: Seeds.PlaybackVideo.currentCell)
        sut.presenter = spy

        // act
        sut.playVideo(with: request)

        // Assert
        XCTAssertTrue(spy.presentMoveCellNextDidCalled, "playVideo는 presentMoveCellNext를 호출하지 않았습니다")
        XCTAssertEqual(sut.previousCell, Seeds.PlaybackVideo.currentCell)
        XCTAssertEqual(spy.presentMoveCellNextResponse.previousCell, Seeds.PlaybackVideo.previousCell)
        XCTAssertEqual(spy.presentMoveCellNextResponse.currentCell, Seeds.PlaybackVideo.currentCell)
        XCTAssertEqual(spy.presentMoveCellNextResponse.indexPathRow, nil)
        if let isTeleport = sut.isTeleport {
            XCTAssertFalse(isTeleport)
        } else {
            XCTFail()
        }
    }

    func test_playTeleportVideo를_호출하면_presentMoveCellNext를_호출한다_무한스크롤상황일_때() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.posts = [Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.thumbnailImageNilPost]
        sut.isTeleport = true
        sut.previousCell = Seeds.PlaybackVideo.previousCell
        let request: Models.DisplayPlaybackVideo.Request = Models.DisplayPlaybackVideo.Request(indexPathRow: 1, currentCell: Seeds.PlaybackVideo.currentCell)
        sut.presenter = spy

        // act
        sut.playTeleportVideo(with: request)

        // Assert
        XCTAssertTrue(spy.presentMoveCellNextDidCalled, "playTeleportvideo는 presentMoveCellNext를 호출하지 않았습니다")
        XCTAssertEqual(spy.presentMoveCellNextResponse.previousCell, Seeds.PlaybackVideo.previousCell)
        XCTAssertEqual(spy.presentMoveCellNextResponse.currentCell, Seeds.PlaybackVideo.currentCell)
        XCTAssertEqual(sut.previousCell, Seeds.PlaybackVideo.currentCell)
        if let isTeleport = sut.isTeleport {
            XCTAssertFalse(isTeleport)
        } else {
            XCTFail()
        }
    }

    func test_playTeleportVideo를_호출하면_presentMoveCellNext를_호출한다_셀이_삭제되는_상황일_때() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.posts = [Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.thumbnailImageNilPost]
        sut.isTeleport = true
        sut.previousCell = Seeds.PlaybackVideo.previousCell
        let request: Models.DisplayPlaybackVideo.Request = Models.DisplayPlaybackVideo.Request(indexPathRow: 1, currentCell: Seeds.PlaybackVideo.currentCell)
        sut.presenter = spy
        // act
        sut.playTeleportVideo(with: request)

        // Assert
        XCTAssertTrue(spy.presentMoveCellNextDidCalled, "playTeleportvideo는 presentMoveCellNext를 호출하지 않았습니다")
        XCTAssertEqual(spy.presentMoveCellNextResponse.previousCell, Seeds.PlaybackVideo.previousCell)
        XCTAssertEqual(spy.presentMoveCellNextResponse.currentCell, Seeds.PlaybackVideo.currentCell)
        XCTAssertEqual(sut.previousCell, Seeds.PlaybackVideo.currentCell)
        XCTAssertFalse(((sut.isDelete) != nil))
    }

    func test_resumePlaybackView를_호출할때_previousCell이_존재하면_presentPlayInitialPlaybackCell을_호출한다() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.previousCell = Seeds.PlaybackVideo.previousCell
        sut.presenter = spy

        // act
        sut.resumePlaybackView()

        // Assert
        XCTAssertTrue(spy.presentPlayInitialPlaybackCellDidCalled, "resumPlaybackView가 presentPlayInitialPlaybackCell을 호출하지 않았습니다")
        XCTAssertEqual(spy.presentPlayInitialPlaybackCellResponse.currentCell, Seeds.PlaybackVideo.previousCell)
        XCTAssertEqual(spy.presentPlayInitialPlaybackCellResponse.previousCell, nil)
    }

    func test_resumePlaybackView를_호출할때_previousCell이_존재하면_presentSetInitialPlaybackCell을_호출한다() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.index = 2
        sut.presenter = spy

        // act
        sut.resumePlaybackView()

        // Assert
        XCTAssertTrue(spy.presentSetInitialPlaybackCellDidCalled, "resumPlaybackView가 presentSetInitialPlaybackCell을 호출하지 않았습니다")
        XCTAssertEqual(spy.presentSetInitialPlaybackCellResponse.indexPathRow, 2)
    }

    func test_leavePlaybackView를_호출할때_presentLeavePlaybackView를_호출한다() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.previousCell = Seeds.PlaybackVideo.previousCell
        sut.presenter = spy
        // act
        sut.leavePlaybackView()

        // Assert
        XCTAssertTrue(spy.presentLeavePlaybackViewDidCalled, "leavePlaybackView가 presentLeavePlaybackView를 호출하지 않았습니다")
        XCTAssertEqual(spy.presentLeavePlaybackViewResponse.previousCell, Seeds.PlaybackVideo.previousCell)
    }

    func test_resetVideo를_호출할때_presentResetPlaybackCell을_호출한다() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.previousCell = Seeds.PlaybackVideo.previousCell
        sut.presenter = spy
        // act
        sut.resetVideo()

        // Assert
        XCTAssertTrue(spy.presentResetPlaybackCellDidCalled, "resetVideo가 presentResetPlaybackCell을 호출하지 않았습니다")
        XCTAssertEqual(spy.presentResetPlaybackCellResponse.previousCell, nil)
        XCTAssertEqual(spy.presentResetPlaybackCellResponse.currentCell, Seeds.PlaybackVideo.previousCell)
    }

    func test_careVideoLoading을_호출할때_presentMoveCellNext를_호출하지않는다_previousCell이_존재할때() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.previousCell = Seeds.PlaybackVideo.previousCell
        let request: Models.DisplayPlaybackVideo.Request = Models.DisplayPlaybackVideo.Request(indexPathRow: nil, currentCell: nil)
        // act
        sut.careVideoLoading(with: request)

        // Assert
        XCTAssertFalse(spy.presentMoveCellNextDidCalled, "careVideoLoading은 presentMoveCellNext를 호출하지 않았습니다")
    }

    func test_careVideoLoading을_호출할때_presentMoveCellNext를_호출하지않는다_previousCell이_존재하지않을때() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.previousCell = nil
        sut.presenter = spy
        let request: Models.DisplayPlaybackVideo.Request = Models.DisplayPlaybackVideo.Request(indexPathRow: nil, currentCell: Seeds.PlaybackVideo.currentCell)
        // act
        sut.careVideoLoading(with: request)

        // Assert
        XCTAssertTrue(spy.presentMoveCellNextDidCalled, "careVideoLoading은 presentMoveCellNext를 호출하지 않았습니다")
        XCTAssertEqual(spy.presentMoveCellNextResponse.previousCell, nil)
        XCTAssertEqual(spy.presentMoveCellNextResponse.currentCell, Seeds.PlaybackVideo.currentCell)
    }

    func test_configurePlaybackCell을_호출할때_presentConfigureCell을_호출한다_map일때() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.posts = [Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.thumbnailImageNilPost]
        sut.parentView = .map
        sut.presenter = spy

        // act
        sut.configurePlaybackCell()

        // Assert
        XCTAssertTrue(spy.presentConfigureCellDidCalled, "configurePlaybackCell은 presentConfigureCell을 호출하지 않았습니다")
        XCTAssertEqual(spy.presentConfigureCellResponse.teleportIndex, 4)
    }

    func test_configurePlaybackCell을_호출할때_presentConfigureCell을_호출한다_map이_아닐때() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.posts = [Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.thumbnailImageNilPost]
        sut.parentView = .home
        sut.presenter = spy

        // act
        sut.configurePlaybackCell()

        // Assert
        XCTAssertTrue(spy.presentConfigureCellDidCalled, "configurePlaybackCell은 presentConfigureCell을 호출하지 않았습니다")
    }

    func test_setSeemoreButton을_호출할때_presentSetSeemoreButton을_호출하고_올바른_데이터를_전달한다_본인일경우() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.previousCell = Seeds.PlaybackVideo.previousCell
        sut.previousCell?.memberID = -1
        sut.presenter = spy

        // act
        sut.setSeeMoreButton()

        // Assert
        XCTAssertTrue(spy.presentSetSeemoreButtonDidCalled, "")
        XCTAssertEqual(spy.presentSetSeemoreButtonResponse.buttonType, .delete)
    }

    func test_setSeemoreButton을_호출할때_presentSetSeemoreButton을_호출하고_올바른_데이터를_전달한다_본인이아닐경우() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.previousCell = Seeds.PlaybackVideo.previousCell
        sut.previousCell?.memberID = 1
        sut.presenter = spy

        // act
        sut.setSeeMoreButton()

        // Assert
        XCTAssertTrue(spy.presentSetSeemoreButtonDidCalled, "")
        XCTAssertEqual(spy.presentSetSeemoreButtonResponse.buttonType, .report)
    }

    func test_moveToProfile을_호출할때_presentProfile이_호출된다() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        let request: Models.MoveToRelativeView.Request = Models.MoveToRelativeView.Request(memberID: 1, selectedTag: nil)
        sut.presenter = spy

        // act
        sut.moveToProfile(with: request)

        // Assert
        XCTAssertTrue(spy.presentProfileDidCalled, "moveToProfile이 presentProfileDidCalled를 호출하지 않았습니다")
        XCTAssertEqual(sut.memberID, 1)
    }

    func test_moveToTagPlay를_호출할때_presentTagPlay가_호출된다() {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        let request: Models.MoveToRelativeView.Request = Models.MoveToRelativeView.Request(memberID: nil, selectedTag: "테스트")
        sut.presenter = spy

        // act
        sut.moveToTagPlay(with: request)

        // Assert
        XCTAssertTrue(spy.presentTagPlayDidCalled, "moveToTagPlay이 presentTagPlay를 호출하지 않았습니다")
        XCTAssertEqual(sut.selectedTag, "테스트")
    }

    func test_fetchPosts를_호출하면_presentLoadFetchVideosResponse를_호출한다_Home() async {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.parentView = .home
        sut.posts = [Seeds.Posts.post1, Seeds.Posts.post2]
        sut.presenter = spy
        sut.currentPage = 1
        sut.isFetchReqeust = false

        // act
        let result = await sut.fetchPosts().value

        // Assert
        XCTAssertTrue(spy.presentLoadFetchVideosDidCalled, "fetchPosts가 presentLoadFetchVideos를 호출하지 않았습니다")
        XCTAssertTrue(result, "fetchPost에 실패했습니다.")
        XCTAssertEqual(spy.presentLoadFetchVideosResponse.videos.count, 1)
        XCTAssertEqual(sut.posts?.count, 3)
    }

    func test_fetchPosts를_호출하면_presentLoadFetchVideos를_호출한다_tag() async throws {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.parentView = .tag
        sut.posts = [Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.post1, Seeds.Posts.post2]
        sut.selectedTag = "테스트"
        sut.presenter = spy
        sut.currentPage = 1
        sut.isFetchReqeust = false

        // act
        let result = await sut.fetchPosts().value
        try await Task.sleep(nanoseconds: 3_000_000_000)

        // Assert
        XCTAssertTrue(spy.presentLoadFetchVideosDidCalled, "fetchPosts가 presentLoadFetchVideos를 호출하지 않았습니다")
        XCTAssertTrue(result, "fetchPost에 실패했습니다.")
        XCTAssertEqual(spy.presentLoadFetchVideosResponse.videos.count, 1)
        XCTAssertEqual(sut.posts?.count, 21)
    }

    func test_fetchPosts를_호출하면_presentLoadFetchVideos를_호출한다_Profile() async throws {
        // Arrange
        let spy = PlaybackPresentationLogicSpy()
        sut.parentView = .otherProfile
        sut.posts = [Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.post1, Seeds.Posts.post2, Seeds.Posts.post1, Seeds.Posts.post2]
        sut.presenter = spy
        sut.memberID = -1
        sut.currentPage = 1
        sut.isFetchReqeust = false
        
        // act
        let result = await sut.fetchPosts().value

        // Assert
        XCTAssertTrue(spy.presentLoadFetchVideosDidCalled, "fetchPosts가 presentLoadFetchVideos를 호출하지 않았습니다")
        XCTAssertTrue(result, "fetchPost에 실패했습니다.")
        XCTAssertEqual(spy.presentLoadFetchVideosResponse.videos.count, 1)
        XCTAssertEqual(sut.posts?.count, 21)
    }
}
