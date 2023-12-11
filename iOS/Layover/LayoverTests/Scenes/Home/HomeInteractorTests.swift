//
//  HomeInteractorTests.swift
//  Layover
//
//  Created by 김인환 on 12/4/23.
//  Copyright (c) 2023 CodeBomber. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import Layover
import XCTest

final class HomeInteractorTests: XCTestCase {

    // MARK: Subject under test
    typealias Models = HomeModels
    var sut: HomeInteractor!

    // MARK: - Test lifecycle

    override func setUp() {
        super.setUp()
        setupHomeInteractor()
    }

    // MARK: - Test setup

    func setupHomeInteractor() {
        sut = HomeInteractor()
        sut.homeWorker = MockHomeWorker()
    }

    // MARK: - Test doubles

    final class HomePresentationLogicSpy: HomePresentationLogic { // 호출 테스트를 위한 Spy
        var presentPostsCalled = false
        var presentPostsReceivedResponse: Models.FetchPosts.Response!
        var presentPlaybackSceneCalled = false
        var presentTagPlayListCalled = false

        func presentPosts(with response: Models.FetchPosts.Response) {
            presentPostsCalled = true
            presentPostsReceivedResponse = response
        }

        func presentPlaybackScene(with response: Models.PlayPosts.Response) {
            presentPlaybackSceneCalled = true
        }

        func presentTagPlayList(with response: Models.ShowTagPlayList.Response) {
            presentTagPlayListCalled = true
        }
    }

    // MARK: - Tests

    func test_fetchPost는_presenter의_presentPosts를_호출한다() async throws {
        // Arrange
        let spy = HomePresentationLogicSpy()
        sut.presenter = spy
        let request = Models.FetchPosts.Request()

        // Act
        _ = await sut.fetchPosts(with: request).value

        // Assert
        XCTAssertTrue(spy.presentPostsCalled, "fetchPost()가 presenter의 presentPosts()를 호출했다.")
    }

    func test_fetchPost는_presenter에게_올바른_데이터를_전달한다() async throws {
        // Arrange
        let spy = HomePresentationLogicSpy()
        sut.presenter = spy
        let request = Models.FetchPosts.Request()

        // Act
        _ = await sut.fetchPosts(with: request).value

        // Assert
        XCTAssertEqual(spy.presentPostsReceivedResponse.posts.count, 4, "fetchPost()가 presenter에게 올바른 데이터를 저장했다.")
    }

    func test_fetchPost는_presenter에게_올바른_이미지_데이터를_전달한다() async throws {
        // Arrange
        let spy = HomePresentationLogicSpy()
        sut.presenter = spy
        let request = Models.FetchPosts.Request()
        let imageData = try Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "sample", withExtension: "jpeg")!)

        // Act
        _ = await sut.fetchPosts(with: request).value

        // Assert
        spy.presentPostsReceivedResponse.posts.forEach {
            XCTAssertEqual($0.thumbnailImageData, imageData, "fetchPost()가 presenter에게 올바른 이미지 데이터를 전달했다.")
        }
    }

    func test_playPosts는_자신의_selectedIndex값을_변경한다() async throws {
        // Arrange
        let request = Models.PlayPosts.Request(selectedIndex: 101)

        // Act
        sut.playPosts(with: request)

        // Assert
        XCTAssertEqual(sut.postPlayStartIndex, 101, "playPosts()가 자신의 selectedIndex를 변경했다.")
    }

    func test_playPosts는_presenter의_presentPlaybackScene를_호출한다() async throws {
        // Arrange
        let spy = HomePresentationLogicSpy()
        sut.presenter = spy
        let request = Models.PlayPosts.Request(selectedIndex: 0)

        // Act
        sut.playPosts(with: request)

        // Assert
        XCTAssertTrue(spy.presentPlaybackSceneCalled, "playPosts()가 presenter의 presentPlaybackScene()를 호출했다.")
    }

    // TODO: - videoFileWorker Mock 객체 생성 후 테스트 코드 작성
//    func testSelectVideo는_자신의_selectedVideoURL값을_변경한다() {
//        // Arrange
//        guard let dummyVideoURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8") else {
//            XCTFail("URL 생성 실패")
//            return
//        }
//        let request = Models.SelectVideo.Request(videoURL: dummyVideoURL)
//
//        // Act
//        sut.selectVideo(with: request)
//
//        // Assert
//
//        guard let selectedVideoURL = sut.selectedVideoURL else {
//            XCTFail("selectedVideoURL이 nil")
//            return
//        }
//
//        XCTAssertEqual(selectedVideoURL, dummyVideoURL)
//    }

    func test_showTagPlayList는_자신의_selectedTag값을_변경한다() {
        // Arrange
        let request = Models.ShowTagPlayList.Request(tag: "DummyTag")

        // Act
        sut.showTagPlayList(with: request)

        // Assert
        XCTAssertEqual(sut.selectedTag, "DummyTag", "showTagPlayList()가 자신의 selectedTag를 변경했다.")
    }

    func test_showTagPlayList는_presenter의_presentTagPlayList를_호출한다() {
        // Arrange
        let spy = HomePresentationLogicSpy()
        sut.presenter = spy
        let request = Models.ShowTagPlayList.Request(tag: "DummyTag")

        // Act
        sut.showTagPlayList(with: request)

        // Assert
        XCTAssertTrue(spy.presentTagPlayListCalled, "showTagPlayList()가 presenter의 presentTagPlayList()를 호출했다.")
    }
}