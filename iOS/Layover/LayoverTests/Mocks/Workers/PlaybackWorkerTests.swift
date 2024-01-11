//
//  PlaybackWorkerTests.swift
//  LayoverTests
//
//  Created by 황지웅 on 1/11/24.
//  Copyright © 2024 CodeBomber. All rights reserved.
//

@testable import Layover
import XCTest

final class PlaybackWorkerTests: XCTestCase {
    // MARK: Subject under test

    typealias Models = PlaybackModels
    var sut: PlaybackWorker!

    // MARK: - Test lifecycle

    override func setUp() {
        super.setUp()
        setupPlaybackWorker()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Test setup

    func setupPlaybackWorker() {
        sut = PlaybackWorker(provider: Provider(session: .initMockSession()), authManager: StubAuthManager())
    }

    func test_makeInfiniteScroll은_올바른_결과를_반환한다() {
        // Arrange
        let testPosts: [Post] = [Seeds.Posts.post1, Seeds.Posts.post2]

        // act
        let result: [Post] = sut.makeInfiniteScroll(posts: testPosts)

        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result[0].board.identifier, Seeds.Posts.post2.board.identifier)
        XCTAssertEqual(result[1].board.identifier, Seeds.Posts.post1.board.identifier)
        XCTAssertEqual(result[2].board.identifier, Seeds.Posts.post2.board.identifier)
        XCTAssertEqual(result[3].board.identifier, Seeds.Posts.post1.board.identifier)
    }

    func test_deletePlaybackVideo는_올바른_동작을_반환한다() {
        // Arrange
        guard let mockFileLocation = Bundle(for: type(of: self)).url(forResource: "DeleteVideo", withExtension: "json"),
              let mockData = try? Data(contentsOf: mockFileLocation) else {
            XCTFail("Mock json 파일 로드 실패.")
            return
        }

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response, mockData, nil)
        }

        Task {
            let response = await sut.deletePlaybackVideo(boardID: 1)

            XCTAssertNotNil(response, "deleteVideo가 response를 정상적으로 반환하지 못함")
        }
    }

    func test_fetchHomePosts는_올바른_목록을_반환한다() {
        // Arrange
        guard let mockFileLocation = Bundle(for: type(of: self)).url(forResource: "PostList", withExtension: "json"),
              let mockData = try? Data(contentsOf: mockFileLocation) else {
            XCTFail("Mock json 파일 로드 실패.")
            return
        }

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response, mockData, nil)
        }

        Task {
            // act
            let result = await sut.fetchHomePosts()

            // assert
            XCTAssertNotNil(result)
            XCTAssertEqual(result?.count, 1, "fetchPost가 성공적으로 데이터를 받아와서 올바른 데이터 갯수를 리턴하지 못했다.")
            XCTAssertEqual(result![0].tag, Seeds.Posts.post1.tag, "fetchPost가 성공적으로 데이터를 받아와서 올바른 tag를 리턴하지 못했다.")
            XCTAssertEqual(result![0].board.thumbnailImageURL, Seeds.Posts.post1.board.thumbnailImageURL, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
            XCTAssertEqual(result![0].board.identifier, Seeds.Posts.post1.board.identifier, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
            XCTAssertEqual(result![0].board.title, Seeds.Posts.post1.board.title, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
            XCTAssertEqual(result![0].board.description, Seeds.Posts.post1.board.description, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
            XCTAssertEqual(result![0].board.videoURL, Seeds.Posts.post1.board.videoURL, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
            XCTAssertEqual(result![0].board.latitude, Seeds.Posts.post1.board.latitude, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
            XCTAssertEqual(result![0].board.longitude, Seeds.Posts.post1.board.longitude, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
            XCTAssertEqual(result![0].board.status, Seeds.Posts.post1.board.status, "fetchPost가 성공적으로 데이터를 받아와서 Post배열을 리턴하지 못했다.")
            XCTAssertEqual(result![0].member.identifier, Seeds.Posts.post1.member.identifier, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
            XCTAssertEqual(result![0].member.username, Seeds.Posts.post1.member.username, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
            XCTAssertEqual(result![0].member.introduce, Seeds.Posts.post1.member.introduce, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
            XCTAssertEqual(result![0].member.profileImageURL, Seeds.Posts.post1.member.profileImageURL, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
        }
    }

    func test_fetchProfilePosts_는_올바른_결과를_반환한다() async {
        // Arrange
        guard let mockFileLocation = Bundle(for: type(of: self)).url(forResource: "PostListMore", withExtension: "json"),
              let mockData = try? Data(contentsOf: mockFileLocation)
        else {
            XCTFail("Mock json 파일 로드 실패.")
            return
        }

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response, mockData, nil)
        }

        Task {
            // act
            let result = await sut.fetchProfilePosts(profileID: 2, page: 1)
            
            // assert
            XCTAssertNotNil(result)
        }
    }
}
