//
//  PlaybackPresenterTests.swift
//  LayoverTests
//
//  Created by 황지웅 on 12/12/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

@testable import Layover
import XCTest

final class PlaybackPresenterTests: XCTestCase {
    // MARK: Subject under test

    var sut: PlaybackPresenter!

    typealias Models = PlaybackModels

    // MARK: - Test lifecycle

    override func setUp() {
        super.setUp()
        setupPlaybackPresenter()

    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Test setup

    func setupPlaybackPresenter() {
        sut = PlaybackPresenter()
    }

    // MARK: - Test doubles

    final class PlaybackDisplayLogicSpy: PlaybackDisplayLogic {
        var displayVideoListDidCalled = false
        var displayVideoListViewModel: Models.LoadPlaybackVideoList.ViewModel!
        
        var loadFetchVideosDidCalled = false
        var loadFetchVideosViewModel: Models.LoadPlaybackVideoList.ViewModel!
        
        var setInitialPlaybackCellDidCalled = false
        var setInitialPlaybackCellViewModel: Models.SetInitialPlaybackCell.ViewModel!

        var moveInitialPlaybackCellDidCalled = false
        var moveInitialPlaybackCellViewModel: Models.SetInitialPlaybackCell.ViewModel!

        var stopPrevPlayerAndPlayCurPlayerDidCalled = false
        var stopPrevPlayerAndPlayCurPlayerViewModel: Models.DisplayPlaybackVideo.ViewModel!

        var showPlayerSliderDidCalled = false
        var showPlayerSliderViewModel: Models.DisplayPlaybackVideo.ViewModel!

        var teleportPlaybackCellDidCalled = false
        var teleportPlaybackCellViewModel: Models.DisplayPlaybackVideo.ViewModel!

        var leavePlaybackViewDidCalled = false
        var leavePlaybackViewViewModel: Models.DisplayPlaybackVideo.ViewModel!

        var resetVideoDidCalled = false
        var resetVideoViewModel: Models.DisplayPlaybackVideo.ViewModel!

        var configureDataSourceDidCalled = false
        var configureDataSourceViewModel: Models.ConfigurePlaybackCell.ViewModel!

        var setSeemoreButtonDidCalled = false
        var setSeemoreButtonViewModel: Models.SetSeemoreButton.ViewModel!

        var deleteVideoDidCalled = false
        var deleteVideoViewModel: Models.DeletePlaybackVideo.ViewModel!

        var routeToProfileDidCalled = false

        var routeToTagPlayDidCalled = false

        var setProfileImageAndLocationDidCalled = false
        var setProfileImageAndLocationViewModel: Models.LoadProfileImageAndLocation.ViewModel!

        func displayVideoList(viewModel: Layover.PlaybackModels.LoadPlaybackVideoList.ViewModel) {
            displayVideoListDidCalled = true
            displayVideoListViewModel = viewModel
        }
        
        func loadFetchVideos(viewModel: Layover.PlaybackModels.LoadPlaybackVideoList.ViewModel) {
            loadFetchVideosDidCalled = true
            loadFetchVideosViewModel = viewModel
        }
        
        func setInitialPlaybackCell(viewModel: Layover.PlaybackModels.SetInitialPlaybackCell.ViewModel) {
            setInitialPlaybackCellDidCalled = true
            setInitialPlaybackCellViewModel = viewModel
        }

        func moveInitialPlaybackCell(viewModel: Layover.PlaybackModels.SetInitialPlaybackCell.ViewModel) {
            moveInitialPlaybackCellDidCalled = true
            moveInitialPlaybackCellViewModel = viewModel
        }

        func stopPrevPlayerAndPlayCurPlayer(viewModel: Layover.PlaybackModels.DisplayPlaybackVideo.ViewModel) {
            stopPrevPlayerAndPlayCurPlayerDidCalled = true
            stopPrevPlayerAndPlayCurPlayerViewModel = viewModel
        }

        func showPlayerSlider(viewModel: Layover.PlaybackModels.DisplayPlaybackVideo.ViewModel) {
            showPlayerSliderDidCalled = true
            showPlayerSliderViewModel = viewModel
        }
        
        func teleportPlaybackCell(viewModel: Layover.PlaybackModels.DisplayPlaybackVideo.ViewModel) {
            teleportPlaybackCellDidCalled = true
            teleportPlaybackCellViewModel = viewModel
        }
        
        func leavePlaybackView(viewModel: Layover.PlaybackModels.DisplayPlaybackVideo.ViewModel) {
            leavePlaybackViewDidCalled = true
            leavePlaybackViewViewModel = viewModel
        }
        
        func resetVideo(viewModel: Layover.PlaybackModels.DisplayPlaybackVideo.ViewModel) {
            resetVideoDidCalled = true
            resetVideoViewModel = viewModel
        }
        
        func configureDataSource(viewModel: Layover.PlaybackModels.ConfigurePlaybackCell.ViewModel) {
            configureDataSourceDidCalled = true
            configureDataSourceViewModel = viewModel
        }

        func setSeemoreButton(viewModel: Layover.PlaybackModels.SetSeemoreButton.ViewModel) {
            setSeemoreButtonDidCalled = true
            setSeemoreButtonViewModel = viewModel
        }
        
        func deleteVideo(viewModel: Layover.PlaybackModels.DeletePlaybackVideo.ViewModel) {
            deleteVideoDidCalled = true
            deleteVideoViewModel = viewModel
        }
        
        func routeToProfile() {
            routeToProfileDidCalled = true
        }
        
        func routeToTagPlay() {
            routeToTagPlayDidCalled = true
        }
        
        func setProfileImageAndLocation(viewModel: Layover.PlaybackModels.LoadProfileImageAndLocation.ViewModel) {
            setProfileImageAndLocationDidCalled = true
            setProfileImageAndLocationViewModel = viewModel
        }
    }

    // MARK: - Tests

    func test_presentVideoList를_호출하면_displayVideoList를_호출하고_올바른_데이터를_전달한다() {
        let spy = PlaybackDisplayLogicSpy()
        sut.viewController = spy
        let response: Models.LoadPlaybackVideoList.Response = Models.LoadPlaybackVideoList.Response(videos: Seeds.PlaybackVideos.videos)
        // act
        sut.presentVideoList(with: response)
        
        // assert
        XCTAssertTrue(spy.displayVideoListDidCalled, "presentProfile은 displayVideoList를 호출했다")
        // videos는 Hashable
        XCTAssertEqual(spy.displayVideoListViewModel.videos.first!, Seeds.PlaybackVideos.videos.first!)
        XCTAssertEqual(spy.displayVideoListViewModel.videos.last!, Seeds.PlaybackVideos.videos.last!)
        XCTAssertEqual(spy.displayVideoListViewModel.videos.count, 2)
    }

    func test_presentLoadFetchVideos를_호출하면_loadFetchVideos를_호출하고_올바른_데이터를_전달한다() {
        let spy = PlaybackDisplayLogicSpy()
        sut.viewController = spy
        let response: Models.LoadPlaybackVideoList.Response = Models.LoadPlaybackVideoList.Response(videos: Seeds.PlaybackVideos.videos)
        // act
        sut.presentLoadFetchVideos(with: response)

        // assert
        XCTAssertTrue(spy.loadFetchVideosDidCalled, "presentLoadFetchVideos는 loadFetchVideos를 호출했다")
        XCTAssertEqual(spy.loadFetchVideosViewModel.videos.first!, Seeds.PlaybackVideos.videos.first!)
        XCTAssertEqual(spy.loadFetchVideosViewModel.videos.last!, Seeds.PlaybackVideos.videos.last!)
        XCTAssertEqual(spy.loadFetchVideosViewModel.videos.count, 2)
    }

    func test_presentSetInitialPlaybackCell을_호출하면_setInitialPlaybackCell을_호출하고_올바른_데이터를_전달한다() {
        let spy = PlaybackDisplayLogicSpy()
        sut.viewController = spy
        let response: Models.SetInitialPlaybackCell.Response = Models.SetInitialPlaybackCell.Response(indexPathRow: 1)
        // act
        sut.presentSetInitialPlaybackCell(with: response)

        // assert
        XCTAssertTrue(spy.setInitialPlaybackCellDidCalled, "presentSetInitialPlaybackCell은 setInitialPlaybackCell을 호출했다")
        XCTAssertEqual(spy.setInitialPlaybackCellViewModel.indexPathRow, 1)
    }

    func test_presentMoveInitialPlaybackCell을_호출하면_moveInitialPlaybackCell을_호출하고_올바른_데이터를_전달한다() {
        let spy = PlaybackDisplayLogicSpy()
        sut.viewController = spy
        let response: Models.SetInitialPlaybackCell.Response = Models.SetInitialPlaybackCell.Response(indexPathRow: 1)
        // act
        sut.presentMoveInitialPlaybackCell(with: response)

        // assert
        XCTAssertTrue(spy.moveInitialPlaybackCellDidCalled, "presentMoveInitialPlaybackCell은 moveInitialPlaybackCell을 호출했다")
        XCTAssertEqual(spy.moveInitialPlaybackCellViewModel.indexPathRow, 1)
    }

    func test_presentMoveCellNext를_호출하면_stopPrevPlayerAndPlayCurPlayer를_호출하고_올바른_데이터를_전달한다() {
        let spy = PlaybackDisplayLogicSpy()
        sut.viewController = spy
        let response: Models.DisplayPlaybackVideo.Response = Models.DisplayPlaybackVideo.Response(previousCell: Seeds.PlaybackVideo.previousCell, currentCell: Seeds.PlaybackVideo.currentCell)
        // act
        sut.presentMoveCellNext(with: response)

        // assert
        XCTAssertTrue(spy.stopPrevPlayerAndPlayCurPlayerDidCalled, "presentMoveCellNext는 stopPrevPlayerAndPlayCurPlayerDidCalled를 호출했다")
        // 이전 PlaybackCell과 현재 PlaybackCell은 달라야함
        XCTAssertNotEqual(spy.stopPrevPlayerAndPlayCurPlayerViewModel.previousCell, spy.stopPrevPlayerAndPlayCurPlayerViewModel.currentCell)
        XCTAssertEqual(spy.stopPrevPlayerAndPlayCurPlayerViewModel.previousCell, Seeds.PlaybackVideo.previousCell)
        XCTAssertEqual(spy.stopPrevPlayerAndPlayCurPlayerViewModel.currentCell, Seeds.PlaybackVideo.currentCell)
    }

    func test_presentPlayInitialPlaybackCell을_호출하면_stopPrevPlayerAndPlayCurPlayer를_호출하고_올바른_데이터를_전달한다() {
        let spy = PlaybackDisplayLogicSpy()
        sut.viewController = spy
        let response: Models.DisplayPlaybackVideo.Response = Models.DisplayPlaybackVideo.Response(previousCell: nil, currentCell: Seeds.PlaybackVideo.currentCell)
        // act
        sut.presentPlayInitialPlaybackCell(with: response)

        // assert
        XCTAssertTrue(spy.stopPrevPlayerAndPlayCurPlayerDidCalled, "presentPlayInitialPlaybackCell은 stopPrevPlayerAndPlayCurPlayerDidCalled를 호출했다")
        XCTAssertNotEqual(spy.stopPrevPlayerAndPlayCurPlayerViewModel.previousCell, spy.stopPrevPlayerAndPlayCurPlayerViewModel.currentCell)
        XCTAssertEqual(spy.stopPrevPlayerAndPlayCurPlayerViewModel.previousCell, nil)
        XCTAssertEqual(spy.stopPrevPlayerAndPlayCurPlayerViewModel.currentCell, Seeds.PlaybackVideo.currentCell)
    }

    func test_presentShowPlayerSlider를_호출하면_showPlayerSlider를_호출하고_올바른_데이터를_전달한다() {
        let spy = PlaybackDisplayLogicSpy()
        sut.viewController = spy
        let response: Models.DisplayPlaybackVideo.Response = Models.DisplayPlaybackVideo.Response(previousCell: nil, currentCell: Seeds.PlaybackVideo.currentCell)
        // act
        sut.presentShowPlayerSlider(with: response)

        // assert
        XCTAssertTrue(spy.showPlayerSliderDidCalled, "presentShowPlayerSlider은 showPlayerSlider를 호출했다")
        XCTAssertNotEqual(spy.showPlayerSliderViewModel.previousCell, spy.showPlayerSliderViewModel.currentCell)
        XCTAssertEqual(spy.showPlayerSliderViewModel.previousCell, nil)
        XCTAssertEqual(spy.showPlayerSliderViewModel.currentCell, Seeds.PlaybackVideo.currentCell)
    }

    func test_presentTeleportCell을_호출하면_teleportPlaybackCell을_호출하고_올바른_데이터를_전달한다() {
        let spy = PlaybackDisplayLogicSpy()
        sut.viewController = spy
        let response: Models.DisplayPlaybackVideo.Response = Models.DisplayPlaybackVideo.Response(indexPathRow: 3, previousCell: nil, currentCell: nil)
        // act
        sut.presentTeleportCell(with: response)

        // assert
        XCTAssertTrue(spy.teleportPlaybackCellDidCalled, "presentTeleportCell은 teleportPlaybackCell을 호출했습니다")
        XCTAssertEqual(spy.teleportPlaybackCellViewModel.indexPathRow, 3)
    }

    func test_presentLeavePlaybackView를_호출하면_leavePlaybackView를_호출하고_올바른_데이터를_전달한다() {
        let spy = PlaybackDisplayLogicSpy()
        sut.viewController = spy
        let response: Models.DisplayPlaybackVideo.Response = Models.DisplayPlaybackVideo.Response(previousCell: Seeds.PlaybackVideo.previousCell, currentCell: nil)
        // act
        sut.presentLeavePlaybackView(with: response)

        // assert
        XCTAssertTrue(spy.leavePlaybackViewDidCalled, "presentLeavePlaybackView는 teleportPlaybackCell을 호출했습니다")
        XCTAssertNotEqual(spy.leavePlaybackViewViewModel.previousCell, spy.leavePlaybackViewViewModel.currentCell)
        XCTAssertEqual(spy.leavePlaybackViewViewModel.previousCell, Seeds.PlaybackVideo.previousCell)
        XCTAssertEqual(spy.leavePlaybackViewViewModel.currentCell, nil)
    }

    func test_presentResetPlaybackCell을_호출하면_resetVideo를_호출하고_올바른_데이터를_전달한다() {
        let spy = PlaybackDisplayLogicSpy()
        sut.viewController = spy
        let response: Models.DisplayPlaybackVideo.Response = Models.DisplayPlaybackVideo.Response(previousCell: nil, currentCell: Seeds.PlaybackVideo.currentCell)
        // act
        sut.presentResetPlaybackCell(with: response)

        // assert
        XCTAssertTrue(spy.resetVideoDidCalled, "presentResetPlaybackCell은 resetVideo를 호출했습니다")
        XCTAssertNotEqual(spy.resetVideoViewModel.previousCell, spy.resetVideoViewModel.currentCell)
        XCTAssertEqual(spy.resetVideoViewModel.previousCell, nil)
        XCTAssertEqual(spy.resetVideoViewModel.currentCell, Seeds.PlaybackVideo.currentCell)
    }

    func test_presentConfigureCell을_호출하면_configureDataSource를_호출하고_올바른_데이터를_전달한다() {
        let spy = PlaybackDisplayLogicSpy()
        sut.viewController = spy
        let response: Models.ConfigurePlaybackCell.Response = Models.ConfigurePlaybackCell.Response(teleportIndex: 3)
        // act
        sut.presentConfigureCell(with: response)

        // assert
        XCTAssertTrue(spy.configureDataSourceDidCalled, "presentConfigureDataSource는 configureDataSource를 호출했습니다")
        XCTAssertEqual(spy.configureDataSourceViewModel.teleportIndex, 3)
    }

    func test_presentSetSeemoreButton을_호출하면_setSeemoreButton을_호출하고_올바른_데이터를_전달한다_delete() {
        let spy = PlaybackDisplayLogicSpy()
        sut.viewController = spy
        let response: Models.SetSeemoreButton.Response = Models.SetSeemoreButton.Response(buttonType: .delete)
        // act
        sut.presentSetSeemoreButton(with: response)

        // assert
        XCTAssertTrue(spy.setSeemoreButtonDidCalled, "presentSetSeemoreButton은 setSeemoreButton을 호출했습니다")
        XCTAssertEqual(spy.setSeemoreButtonViewModel.buttonType, .delete)
    }

    func test_presentSetSeemoreButton을_호출하면_setSeemoreButton을_호출하고_올바른_데이터를_전달한다_report() {
        let spy = PlaybackDisplayLogicSpy()
        sut.viewController = spy
        let response: Models.SetSeemoreButton.Response = Models.SetSeemoreButton.Response(buttonType: .delete)
        // act
        sut.presentSetSeemoreButton(with: response)

        // assert
        XCTAssertTrue(spy.setSeemoreButtonDidCalled, "presentSetSeemoreButton은 setSeemoreButton을 호출했습니다")
        XCTAssertEqual(spy.setSeemoreButtonViewModel.buttonType, .delete)
    }

    func test_presentProfile을_호출하면_routeToProfile을_호출한다() {
        let spy = PlaybackDisplayLogicSpy()
        sut.viewController = spy
        // act
        sut.presentProfile()

        // assert
        XCTAssertTrue(spy.routeToProfileDidCalled, "presentProfile은 routeToProfile을 호출했습니다")
    }

    func test_presentTagPlay을_호출하면_routeToTagPlay을_호출한다() {
        let spy = PlaybackDisplayLogicSpy()
        sut.viewController = spy
        // act
        sut.presentTagPlay()

        // assert
        XCTAssertTrue(spy.routeToTagPlayDidCalled, "presentTagPlay는 routeToTagPlay를 호출했습니다")
    }

    func test_presentLoadProfileImageAndLocation을_호출하면_setProfileImageAndLocation을_호출한다_nil일_경우_지역으로_이름_모를_곳을_전달한다() {
        let spy = PlaybackDisplayLogicSpy()
        sut.viewController = spy
        let response: Models.LoadProfileImageAndLocation.Response = Models.LoadProfileImageAndLocation.Response(curCell: Seeds.PlaybackVideo.currentCell, profileImageData: Seeds.PlaybackVideo.profileImageData, location: nil)
        // act
        sut.presentLoadProfileImageAndLocation(with: response)

        // assert
        XCTAssertTrue(spy.setProfileImageAndLocationDidCalled, "presentLoadProfileImageAndLocation은 setProfileImageAndLocation를 호출했습니다")
        XCTAssertEqual(spy.setProfileImageAndLocationViewModel.curCell, Seeds.PlaybackVideo.currentCell)
        XCTAssertEqual(spy.setProfileImageAndLocationViewModel.profileImageData, Seeds.PlaybackVideo.profileImageData)
        XCTAssertEqual(spy.setProfileImageAndLocationViewModel.location, "이름 모를 곳")
    }

    func test_presentLoadProfileImageAndLocation을_호출하면_setProfileImageAndLocation을_호출한다_지역이_존재할_경우_지역으로_지역이름을_전달한다() {
        let spy = PlaybackDisplayLogicSpy()
        sut.viewController = spy
        let response: Models.LoadProfileImageAndLocation.Response = Models.LoadProfileImageAndLocation.Response(curCell: Seeds.PlaybackVideo.currentCell, profileImageData: Seeds.PlaybackVideo.profileImageData, location: "서울특별시")
        // act
        sut.presentLoadProfileImageAndLocation(with: response)

        // assert
        XCTAssertTrue(spy.setProfileImageAndLocationDidCalled, "presentLoadProfileImageAndLocation은 setProfileImageAndLocation를 호출했습니다")
        XCTAssertEqual(spy.setProfileImageAndLocationViewModel.curCell, Seeds.PlaybackVideo.currentCell)
        XCTAssertEqual(spy.setProfileImageAndLocationViewModel.profileImageData, Seeds.PlaybackVideo.profileImageData)
        XCTAssertEqual(spy.setProfileImageAndLocationViewModel.location, "서울특별시")
    }

}
