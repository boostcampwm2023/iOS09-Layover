//
//  TagPlayListInteractorTests.swift
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

final class TagPlayListInteractorTests: XCTestCase {
    // MARK: Subject under test

    var sut: TagPlayListInteractor!

    // MARK: Properties

    typealias Models = TagPlayListModels

    // MARK: - Test lifecycle

    override func setUp() {
        super.setUp()
        setupTagPlayListInteractor()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Test setup

    func setupTagPlayListInteractor() {
        sut = TagPlayListInteractor()
        sut.titleTag = "testTitleTag"
        sut.worker = MockTagPlayListWorker()
    }

    // MARK: - Test doubles

    final class TagPlayListPresentationLogicSpy: TagPlayListPresentationLogic {
        var presentTitleTagCalled = false
        var presentTitleTagResponse: Models.FetchTitleTag.Response!
        var presentPlayListCalled = false
        var presentPlayListResponse: Models.FetchPosts.Response!
        var presentMorePlayListCalled = false
        var presentMorePlayListResponse: Models.FetchMorePosts.Response!
        var presentPostsDetailCalled = false

        func presentTitleTag(response: Models.FetchTitleTag.Response) {
            presentTitleTagCalled = true
            presentTitleTagResponse = response
        }

        func presentPlayList(response: Models.FetchPosts.Response) {
            presentPlayListCalled = true
            presentPlayListResponse = response
        }

        func presentMorePlayList(response: Models.FetchMorePosts.Response) {
            presentMorePlayListCalled = true
            presentMorePlayListResponse = response
        }

        func presentPostsDetail(response: Models.ShowPostsDetail.Response) {
            presentPostsDetailCalled = true
        }


    }

    // MARK: - Tests

    func test_setTitleTag를_호출하면_presenter의_presentTitleTag를_호출하고_자신의_titleTag를_전달한다() {
        // Arrange
        let spy = TagPlayListPresentationLogicSpy()
        sut.presenter = spy
        sut.titleTag = "testTitleTag"
        let request = Models.FetchTitleTag.Request()

        // Act
        sut.setTitleTag(request: request)

        // Assert
        XCTAssertTrue(spy.presentTitleTagCalled, "setTitleTag()가 presenter의 presentTitleTag()를 호출하지 못했다.")
        XCTAssertEqual(sut.titleTag, spy.presentTitleTagResponse.titleTag, "setTitleTag()가 presenter에게 자신의 titleTag를 전달하지 못했다.")
    }

    func test_fetchPlayList를_호출하면_자신의_posts에_데이터를_저장하고_presenter의_presentPlayList를_호출하여_올바른_데이터를_전달한다() async {
        // Arrange
        let spy = TagPlayListPresentationLogicSpy()
        sut.presenter = spy
        let request = Models.FetchPosts.Request()

        // Act
        _ = await sut.fetchPlayList(request: request).value

        // Assert
        XCTAssertTrue(spy.presentPlayListCalled, "fetchPlayList()가 presenter의 presentPlayList()를 호출했다.")
        XCTAssertEqual(sut.posts.count, 1)
        XCTAssertEqual(sut.posts[0].tag, Seeds.Posts.post1.tag)
        XCTAssertNil(sut.posts[0].thumbnailImageData)
        XCTAssertEqual(sut.posts[0].board.identifier, Seeds.Posts.post1.board.identifier)
        XCTAssertEqual(sut.posts[0].board.title, Seeds.Posts.post1.board.title)
        XCTAssertEqual(sut.posts[0].board.description, Seeds.Posts.post1.board.description)
        XCTAssertEqual(sut.posts[0].board.latitude, Seeds.Posts.post1.board.latitude)
        XCTAssertEqual(sut.posts[0].board.longitude, Seeds.Posts.post1.board.longitude)
        XCTAssertEqual(sut.posts[0].board.videoURL, Seeds.Posts.post1.board.videoURL)
        XCTAssertEqual(sut.posts[0].board.thumbnailImageURL, Seeds.Posts.post1.board.thumbnailImageURL)
        XCTAssertEqual(sut.posts[0].member.identifier, Seeds.Posts.post1.member.identifier)
        XCTAssertEqual(sut.posts[0].member.username, Seeds.Posts.post1.member.username)
        XCTAssertEqual(sut.posts[0].member.introduce, Seeds.Posts.post1.member.introduce)
        XCTAssertEqual(sut.posts[0].member.profileImageURL, Seeds.Posts.post1.member.profileImageURL, "fetchPlayList()가 자신의 posts에 올바른 posts 데이터를 저장하지 못했다.")
        XCTAssertEqual(spy.presentPlayListResponse.post.count, 1)
        XCTAssertEqual(spy.presentPlayListResponse.post[0].identifier, Seeds.Posts.post1.board.identifier)
        XCTAssertEqual(spy.presentPlayListResponse.post[0].thumbnailImageData, Seeds.sampleImageData)
        XCTAssertEqual(spy.presentPlayListResponse.post[0].title, Seeds.Posts.post1.board.title, "fetchPlayList()가 presenter에게 올바른 displayedPosts 데이터를 전달하지 못했다.")
    }

    func test_fetchPlayList를_호출하면_기존에_저장된_posts를_비우고_새로운_Posts_데이터를_저장한다() async {
        // Arrange
        let spy = TagPlayListPresentationLogicSpy()
        sut.presenter = spy
        let request = Models.FetchPosts.Request()
        sut.posts = [Seeds.Posts.post2]

        // Act
        _ = await sut.fetchPlayList(request: request).value

        // Assert
        XCTAssert(!sut.posts.contains(where: {
            $0.board.identifier == Seeds.Posts.post2.board.identifier
            && $0.board.title == Seeds.Posts.post2.board.title
            && $0.board.description == Seeds.Posts.post2.board.description
            && $0.board.thumbnailImageURL == Seeds.Posts.post2.board.thumbnailImageURL
            && $0.board.videoURL == Seeds.Posts.post2.board.videoURL
            && $0.board.latitude == Seeds.Posts.post2.board.latitude
            && $0.board.longitude == Seeds.Posts.post2.board.longitude
            && $0.member.identifier == Seeds.Posts.post2.member.identifier
            && $0.member.username == Seeds.Posts.post2.member.username
            && $0.member.introduce == Seeds.Posts.post2.member.introduce
            && $0.member.profileImageURL == Seeds.Posts.post2.member.profileImageURL
            && $0.tag == Seeds.Posts.post2.tag
        }))
        XCTAssertEqual(sut.posts.count, 1)
        XCTAssertEqual(sut.posts[0].tag, Seeds.Posts.post1.tag)
        XCTAssertNil(sut.posts[0].thumbnailImageData)
        XCTAssertEqual(sut.posts[0].board.identifier, Seeds.Posts.post1.board.identifier)
        XCTAssertEqual(sut.posts[0].board.title, Seeds.Posts.post1.board.title)
        XCTAssertEqual(sut.posts[0].board.description, Seeds.Posts.post1.board.description)
        XCTAssertEqual(sut.posts[0].board.latitude, Seeds.Posts.post1.board.latitude)
        XCTAssertEqual(sut.posts[0].board.longitude, Seeds.Posts.post1.board.longitude)
        XCTAssertEqual(sut.posts[0].board.videoURL, Seeds.Posts.post1.board.videoURL)
        XCTAssertEqual(sut.posts[0].board.thumbnailImageURL, Seeds.Posts.post1.board.thumbnailImageURL)
        XCTAssertEqual(sut.posts[0].member.identifier, Seeds.Posts.post1.member.identifier)
        XCTAssertEqual(sut.posts[0].member.username, Seeds.Posts.post1.member.username)
        XCTAssertEqual(sut.posts[0].member.introduce, Seeds.Posts.post1.member.introduce)
        XCTAssertEqual(sut.posts[0].member.profileImageURL, Seeds.Posts.post1.member.profileImageURL, "fetchPlayList()가 자신의 posts에 올바른 posts 데이터를 저장하지 못했다.")
    }

    func test_fetchMorePlayList를_호출하면_자신의_posts에_데이터를_저장하고_presenter의_presentMorePlayList를_호출하여_올바른_Posts_데이터를_전달한다() async {
        // Arrange
        let spy = TagPlayListPresentationLogicSpy()
        sut.presenter = spy
        let fetchRequest = Models.FetchPosts.Request()
        let fetchMoreRequest = Models.FetchMorePosts.Request()

        // Act
        _ = await sut.fetchMorePlayList(request: fetchMoreRequest).value

        // Assert
        XCTAssertTrue(spy.presentMorePlayListCalled, "fetchPlayMoreList()가 presenter의 presentMorePlayList()를 호출하지 못했다.")
        XCTAssertEqual(spy.presentMorePlayListResponse.post.count, 1, "fetchPlayMoreList()가 presenter에게 올바른 갯수의 posts 데이터를 전달하지 못했다.")
        XCTAssertEqual(spy.presentMorePlayListResponse.post[0].identifier, Seeds.Posts.post1.board.identifier)
        XCTAssertEqual(spy.presentMorePlayListResponse.post[0].thumbnailImageData, Seeds.sampleImageData)
        XCTAssertEqual(spy.presentMorePlayListResponse.post[0].title, Seeds.Posts.post1.board.title, "fetchPlayMoreList()가 presenter에게 올바른 displayedPosts 데이터를 전달하지 못했다.")
    }

    func test_fetchMorePlayList를_호출하다가_더이상_가져온_데이터가_없으면_본인의_post개수를_유지하고_presenter의_presentMorePlayList를_호출하여_빈_배열을_전달한다() async {
        // Arrange
        let spy = TagPlayListPresentationLogicSpy()
        sut.presenter = spy
        let request = Models.FetchMorePosts.Request()

        // Act -> 3번 호출 이후 빈 배열을 반환하도록 Mocking됨
        _ = await sut.fetchMorePlayList(request: request).value
        _ = await sut.fetchMorePlayList(request: request).value
        _ = await sut.fetchMorePlayList(request: request).value

        // Assert
        XCTAssertTrue(spy.presentMorePlayListCalled, "fetchPlayMoreList()가 presenter의 presentMorePlayList()를 호출하지 못했다.")
        XCTAssertEqual(sut.posts.count, 2, "fetchPlayMoreList()를 호출하다가 더이상 데이터가 없을 때 자신의 posts를 유지하지 못했다.")
        XCTAssertEqual(spy.presentMorePlayListResponse.post.count, 0, "fetchPlayMoreList()가 presenter에게 빈 배열을 전달하지 못했다.")
    }

    func test_fetchMorePlayList를_호출하면_기존_자신의_posts에_새로운_Posts_데이터가_추가되어_저장한다() async {
        // Arrange
        let spy = TagPlayListPresentationLogicSpy()
        sut.presenter = spy

        sut.posts = [Seeds.Posts.post1]
        let request = Models.FetchMorePosts.Request()

        // Act
        _ = await sut.fetchMorePlayList(request: request).value

        // Assert
        XCTAssertTrue(spy.presentMorePlayListCalled, "fetchPlayMoreList()가 presenter의 presentMorePlayList()를 호출하지 못했다.")
        XCTAssertEqual(sut.posts.filter({
            $0.board.identifier == Seeds.Posts.post1.board.identifier
            && $0.board.title == Seeds.Posts.post1.board.title
            && $0.board.description == Seeds.Posts.post1.board.description
            && $0.board.thumbnailImageURL == Seeds.Posts.post1.board.thumbnailImageURL
            && $0.board.videoURL == Seeds.Posts.post1.board.videoURL
            && $0.board.latitude == Seeds.Posts.post1.board.latitude
            && $0.board.longitude == Seeds.Posts.post1.board.longitude
            && $0.member.identifier == Seeds.Posts.post1.member.identifier
            && $0.member.username == Seeds.Posts.post1.member.username
            && $0.member.introduce == Seeds.Posts.post1.member.introduce
            && $0.member.profileImageURL == Seeds.Posts.post1.member.profileImageURL
            && $0.tag == Seeds.Posts.post1.tag
        }).count, 2)
        XCTAssertEqual(sut.posts.count, 2, "fetchPlayMoreList()가 자신의 posts에 새로운 posts 데이터를 더해서 저장하지 못했다.")
    }

    func test_showPostDetail을_호출하면_자신의_postPlayStartIndex값을_올바르게_저장하고_presenter의_presentPostDetail을_호출한다() {
        // Arrange
        let spy = TagPlayListPresentationLogicSpy()
        sut.presenter = spy
        let request = Models.ShowPostsDetail.Request(startIndex: 7)

        // Act
        sut.showPostsDetail(request: request)

        // Assert
        XCTAssertEqual(sut.postPlayStartIndex, 7, "showPostDetail()가 presenter에게 올바른 startIndex를 전달하지 못했다.")
        XCTAssertTrue(spy.presentPostsDetailCalled, "showPostDetail()가 presenter의 presentPostDetail()를 호출하지 못했다.")
    }
}
