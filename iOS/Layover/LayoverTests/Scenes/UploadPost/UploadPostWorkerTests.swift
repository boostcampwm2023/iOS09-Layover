//
//  UploadPostWorkerTests.swift
//  LayoverTests
//
//  Created by kong on 2023/12/12.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

@testable import Layover
import XCTest

class UploadPostWorkerTests: XCTestCase {

    // MARK: - Subject Under Test (SUT)

    typealias Models = UploadPostModels
    var sut: UploadPostWorker!

    // MARK: - Test Lifecycle

    override func setUp() {
        super.setUp()
        setupUploadPostWorker()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Test Setup

    func setupUploadPostWorker() {
        sut = UploadPostWorker(provider: Provider(session: .initMockSession(), authManager: StubAuthManager()))
    }

    func test_uploadPost는_업로드에_성공하면_올바른결과를_반환한다() async {
        // given
        guard let mockFileLocation = Bundle(for: type(of: self)).url(forResource: "PostBoard", withExtension: "json"),
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

        let request = UploadPost(title: "제목",
                                 content: nil,
                                 latitude: 100,
                                 longitude: 100,
                                 tag: [],
                                 videoURL: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8")!)

        // when
        let response = await sut.uploadPost(with: request)
//        try await Task.sleep(nanoseconds: 3_000_000_000)

        // then
        XCTAssertNotNil(response, "uploadPost가 response를 정상적으로 반환하지 못함")
        XCTAssertEqual(response?.id, 1)
    }

}
