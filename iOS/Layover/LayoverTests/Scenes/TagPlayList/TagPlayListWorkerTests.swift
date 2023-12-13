//
//  TagPlayListWorkerTests.swift
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

final class TagPlayListWorkerTests: XCTestCase {
    // MARK: Subject under test

    var sut: TagPlayListWorker!

    // MARK: - Test lifecycle

    override func setUp() {
        super.setUp()
        setupTagPlayListWorker()
    }

    // MARK: - Test setup

    func setupTagPlayListWorker() {
        sut = TagPlayListWorker(provider: Provider(session: .initMockSession(), authManager: StubAuthManager()),
                                authManager: StubAuthManager())
    }

    // MARK: - Tests

    func test_fetchPlayList를_호출했을때_성공적으로_응답이오면_Post배열을_반환한다() async {
        // arrange
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

        var result: [Post]?

        // act
        result = await sut.fetchPlayList(of: "안유진", at: 1)

        // assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 1, "올바른 갯수의 Post가 반환되지 않았다.")
        XCTAssertEqual(result![0].tag, Seeds.Posts.post1.tag, "올바른 tag가 반환되지 않았다.")
        XCTAssertEqual(result![0].board.title, Seeds.Posts.post1.board.title, "올바른 board title이 반환되지 않았다.")
        XCTAssertEqual(result![0].board.identifier, Seeds.Posts.post1.board.identifier, "올바른 board identifier가 반환되지 않았다.")
        XCTAssertEqual(result![0].board.description, Seeds.Posts.post1.board.description, "올바른 board description이 반환되지 않았다.")
        XCTAssertEqual(result![0].board.thumbnailImageURL, Seeds.Posts.post1.board.thumbnailImageURL, "올바른 board thumbnailImageURL이 반환되지 않았다.")
        XCTAssertEqual(result![0].board.videoURL, Seeds.Posts.post1.board.videoURL, "올바른 board videoURL이 반환되지 않았다.")
        XCTAssertEqual(result![0].board.latitude, Seeds.Posts.post1.board.latitude, "올바른 board latitude가 반환되지 않았다.")
        XCTAssertEqual(result![0].board.longitude, Seeds.Posts.post1.board.longitude, "올바른 board longitude가 반환되지 않았다.")
        XCTAssertEqual(result![0].board.status, Seeds.Posts.post1.board.status, "올바른 board status가 반환되지 않았다.")
        XCTAssertEqual(result![0].member.identifier, Seeds.Posts.post1.member.identifier, "올바른 member identifier가 반환되지 않았다.")
        XCTAssertEqual(result![0].member.username, Seeds.Posts.post1.member.username, "올바른 member username이 반환되지 않았다.")
        XCTAssertEqual(result![0].member.profileImageURL, Seeds.Posts.post1.member.profileImageURL, "올바른 member profileImageURL이 반환되지 않았다.")
        XCTAssertEqual(result![0].member.introduce, Seeds.Posts.post1.member.introduce, "올바른 member introduce가 반환되지 않았다.")
    }

    func test_fetchPlayList를_호출했을때_404_에러가_발생하면_nil을_반환한다() async {
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
        result = await sut.fetchPlayList(of: "안유진", at: 1)

        // assert
        XCTAssertNil(result, "nil이 반환되지 않았다.")
    }

    func test_loadImageData를_호출하면_이미지데이터를_반환한다() async {
        // arrange
        let mockData = Seeds.sampleImageData
        guard let dummyURL = URL(string: "https://www.google.com") else {
            XCTFail("Mock URL 로드 실패.")
            return
        }

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response, mockData, nil)
        }

        var result: Data?

        // act
        result = await sut.loadImageData(from: dummyURL)

        // assert
        XCTAssertNotNil(result)
        XCTAssertEqual(mockData, result)
    }

    func test_loadImageData를_호출했을때_404_에러가_발생하면_nil을_반환한다() async {
        // arrange
        guard let dummyURL = URL(string: "https://www.google.com") else {
            XCTFail("Mock URL 로드 실패.")
            return
        }

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 404,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response, nil, nil)
        }

        var result: Data?

        // act
        result = await sut.loadImageData(from: dummyURL)

        // assert
        XCTAssertNil(result)
    }
}
