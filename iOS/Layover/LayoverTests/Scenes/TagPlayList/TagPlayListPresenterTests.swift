//
//  TagPlayListPresenterTests.swift
//  Layover
//
//  Created by 김인환 on 12/11/23.
//  Copyright (c) 2023 CodeBomber. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import Layover
import XCTest

final class TagPlayListPresenterTests: XCTestCase {
    // MARK: Subject under test

    var sut: TagPlayListPresenter!

    typealias Models = TagPlayListModels

    // MARK: - Test lifecycle

    override func setUp() {
        super.setUp()
        setupTagPlayListPresenter()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Test setup

    func setupTagPlayListPresenter() {
        sut = TagPlayListPresenter()
    }

    // MARK: - Test doubles

    final class TagPlayListDisplayLogicSpy: TagPlayListDisplayLogic {
        var displayPlayListCalled = false
        var displayPlayListViewModel: Models.FetchPosts.ViewModel!
        var displayMorePlayListCalled = false
        var displayMorePlayListViewModel: Models.FetchMorePosts.ViewModel!
        var displayTitleCalled = false
        var displayTitleViewModel: Models.FetchTitleTag.ViewModel!
        var routeToPlaybackCalled = false

        func displayPlayList(viewModel: Models.FetchPosts.ViewModel) {
            displayPlayListCalled = true
            displayPlayListViewModel = viewModel
        }

        func displayMorePlayList(viewModel: Models.FetchMorePosts.ViewModel) {
            displayMorePlayListCalled = true
            displayMorePlayListViewModel = viewModel
        }

        func displayTitle(viewModel: Models.FetchTitleTag.ViewModel) {
            displayTitleCalled = true
            displayTitleViewModel = viewModel
        }

        func routeToPlayback() {
            routeToPlaybackCalled = true
        }


    }

    // MARK: - Tests

    func test_presentPlayList는_뷰컨트롤러의_displayPlayList를_호출하고_올바른_값을_뷰컨트롤러에_전달한다() throws {
        // arrange
        let spy = TagPlayListDisplayLogicSpy()
        sut.viewController = spy
        guard let mockFileLocation = Bundle(for: type(of: self)).url(forResource: "sample", withExtension: "jpeg"),
              let mockData = try? Data(contentsOf: mockFileLocation) else {
            XCTFail("Mock json 파일 로드 실패.")
            return
        }

        let dummyDisplayedPost = Models.DisplayedPost(identifier: 0,
                                                      thumbnailImageData: mockData,
                                                      title: "안유진")

        // act
        sut.presentPlayList(response: .init(post: [dummyDisplayedPost, dummyDisplayedPost, dummyDisplayedPost]))

        // assert
        XCTAssertTrue(spy.displayPlayListCalled, "presentPlayList() 는 displayPlayList()를 호출했다.")
        XCTAssertEqual(spy.displayPlayListViewModel.displayedPost, [dummyDisplayedPost, dummyDisplayedPost, dummyDisplayedPost], "presentPlayList() 는 displayPlayList()에 올바른 값을 전달했다.")
    }

    func test_presentMorePlayList는_뷰컨트롤러의_displayMorePlayList를_호출하고_올바른_값을_뷰컨트롤러에_전달한다() throws {
        // arrange
        let spy = TagPlayListDisplayLogicSpy()
        sut.viewController = spy
        guard let mockFileLocation = Bundle(for: type(of: self)).url(forResource: "sample", withExtension: "jpeg"),
              let mockData = try? Data(contentsOf: mockFileLocation) else {
            XCTFail("Mock json 파일 로드 실패.")
            return
        }

        let dummyDisplayedPost = Models.DisplayedPost(identifier: 0,
                                                      thumbnailImageData: mockData,
                                                      title: "안유진")

        // act
        sut.presentMorePlayList(response: .init(post: [dummyDisplayedPost, dummyDisplayedPost, dummyDisplayedPost]))

        // assert
        XCTAssertTrue(spy.displayMorePlayListCalled, "presentMorePlayList() 는 displayMorePlayList()를 호출했다.")
        XCTAssertEqual(spy.displayMorePlayListViewModel.displayedPost, [dummyDisplayedPost, dummyDisplayedPost, dummyDisplayedPost], "presentMorePlayList() 는 displayMorePlayList()에 올바른 값을 전달했다.")
    }

    func test_presentTitle은_뷰컨트롤러의_displayTitle를_호출하고_올바른_title값을_뷰컨트롤러에_전달한다() {
        // arrange
        let spy = TagPlayListDisplayLogicSpy()
        sut.viewController = spy

        // act
        sut.presentTitleTag(response: .init(titleTag: "안유진"))

        // assert
        XCTAssertTrue(spy.displayTitleCalled, "presentTitle() 는 displayTitle()를 호출했다.")
        XCTAssertEqual(spy.displayTitleViewModel.title, "안유진", "presentTitle() 는 displayTitle()에 올바른 title을 전달했다.")
    }

    func test_presentPostsDetail은_routeToPlayback을_호출한다() {
        // arrange
        let spy = TagPlayListDisplayLogicSpy()
        sut.viewController = spy

        // act
        sut.presentPostsDetail(response: .init())

        // assert
        XCTAssertTrue(spy.routeToPlaybackCalled, "presentPlayback() 는 routeToPlayback()를 호출했다.")
    }
}