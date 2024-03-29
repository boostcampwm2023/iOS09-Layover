//
//  HomeWorkerTests.swift
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

final class HomeWorkerTests: XCTestCase {
    // MARK: Subject under test

    var sut: HomeWorker!

    // MARK: - Test lifecycle

    override func setUp() {
        super.setUp()
        setupHomeWorker()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Test setup

    func setupHomeWorker() {
        sut = HomeWorker(provider: Provider(session: .initMockSession(), authManager: StubAuthManager()))
    }

    // MARK: - Tests

    func test_fetchPost는_성공적으로_데이터를_받아오면_Post배열을_리턴한다() async throws {
        // arrange
        guard let mockFileLocation = Bundle(for: type(of: self)).url(forResource: "PostsPage", withExtension: "json"),
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
        var result: [Post]?

        // act
        result = await sut.fetchPosts()?.posts

        // assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 1, "fetchPost가 성공적으로 데이터를 받아와서 올바른 데이터 갯수를 리턴하지 못했다.")
        XCTAssertEqual(result![0].tag, Seeds.PostsPage.post1.tag, "fetchPost가 성공적으로 데이터를 받아와서 올바른 tag를 리턴하지 못했다.")
        XCTAssertEqual(result![0].board.thumbnailImageURL, Seeds.PostsPage.post1.board.thumbnailImageURL, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
        XCTAssertEqual(result![0].board.identifier, Seeds.PostsPage.post1.board.identifier, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
        XCTAssertEqual(result![0].board.title, Seeds.PostsPage.post1.board.title, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
        XCTAssertEqual(result![0].board.description, Seeds.PostsPage.post1.board.description, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
        XCTAssertEqual(result![0].board.videoURL, Seeds.PostsPage.post1.board.videoURL, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
        XCTAssertEqual(result![0].board.latitude, Seeds.PostsPage.post1.board.latitude, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
        XCTAssertEqual(result![0].board.longitude, Seeds.PostsPage.post1.board.longitude, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
        XCTAssertEqual(result![0].board.status, Seeds.PostsPage.post1.board.status, "fetchPost가 성공적으로 데이터를 받아와서 Post배열을 리턴하지 못했다.")
        XCTAssertEqual(result![0].member.identifier, Seeds.PostsPage.post1.member.identifier, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
        XCTAssertEqual(result![0].member.username, Seeds.PostsPage.post1.member.username, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
        XCTAssertEqual(result![0].member.introduce, Seeds.PostsPage.post1.member.introduce, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
        XCTAssertEqual(result![0].member.profileImageURL, Seeds.PostsPage.post1.member.profileImageURL, "fetchPost가 성공적으로 데이터를_받아와서 Post배열을 리턴하지 못했다.")
    }

    func test_fetchPost는_데이터를_받아오지_못하면_nil을_리턴한다() async {
        // arrange
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 404,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response, nil, nil)
        }
        var result: [Post]?

        // act
        result = await sut.fetchPosts()?.posts

        // assert
        XCTAssertNil(result)
    }
}
