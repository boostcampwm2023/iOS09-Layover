//
//  UploadPostInteractorTests.swift
//  LayoverTests
//
//  Created by kong on 2023/12/12.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

@testable import Layover
import XCTest

class UploadPostInteractorTests: XCTestCase {

    // MARK: - Subject Under Test (SUT)

    typealias Models = UploadPostModels
    var sut: UploadPostInteractor!

    // MARK: - Test Lifecycle

    override func setUp() {
        super.setUp()
        setupUploadPostInteractor()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Test Setup

    func setupUploadPostInteractor() {
        sut = UploadPostInteractor(locationManager: CurrentLocationManager(locationFetcher: MockLocationFetcher()))
        sut.worker = MockUploadPostWorker(provider: Provider(session: .initMockSession()))
    }

    // MARK: - Test Doubles

    class UploadPostPresentationLogicSpy: UploadPostPresentationLogic {

        // MARK: Spied Methods

        var presentTagCalled = false
        var presentTagsResponse: UploadPostModels.FetchTags.Response!
        func presentTags(with response: Layover.UploadPostModels.FetchTags.Response) {
            presentTagCalled = true
            presentTagsResponse = response
        }

        var presentThumbnailCalled = false
        var presentThumbnailResponse: UploadPostModels.FetchThumbnail.Response!
        func presentThumbnailImage(with response: Layover.UploadPostModels.FetchThumbnail.Response) {
            presentThumbnailCalled = true
            presentThumbnailResponse = response
        }

        var presentCurrentAddressCalled = false
        var presentCurrentAddressResponse: UploadPostModels.FetchCurrentAddress.Response!
        func presentCurrentAddress(with response: Layover.UploadPostModels.FetchCurrentAddress.Response) {
            presentCurrentAddressCalled = true
            presentCurrentAddressResponse = response
        }

        var presentUploadButtonCalled = false
        var presentUploadButtonResponse: UploadPostModels.CanUploadPost.Response!
        func presentUploadButton(with response: Layover.UploadPostModels.CanUploadPost.Response) {
            presentUploadButtonCalled = true
            presentUploadButtonResponse = response
        }

    }

    // MARK: - Tests

    func test_fetchTags를_호출하면_presenter의_presentTags가_호출된다() {
        // given
        let spy = UploadPostPresentationLogicSpy()
        sut.presenter = spy

        // when
        sut.fetchTags()

        // then
        XCTAssertTrue(spy.presentTagCalled, "fetchTags 함수가 presentTags을 호출하지 못함")
    }

    func test_fetchTags를_호출하면_datastore에_tags데이터가_전달된다() {
        // given
        let spy = UploadPostPresentationLogicSpy()
        sut.presenter = spy

        // when
        sut.fetchTags()

        // then
        XCTAssertNotNil(sut.tags, "fetchTags 함수가 datastore에 tags 데이터를 전달하지 못함")
    }

    func test_fetchCurrentAddress를_호출하면_presenter의_presentCurrentAddress가_호출된다() async throws {
        // given
        let spy = UploadPostPresentationLogicSpy()
        sut.presenter = spy

        // when
        sut.fetchCurrentAddress()
        try await Task.sleep(nanoseconds: 3_000_000_000)

        // then
        XCTAssertTrue(spy.presentCurrentAddressCalled, "fetchCurrentAddress 함수가 presentCurrentAddress을 호출하지 못함")
    }

    func test_fetchCurrentAddress를_호출하면_presenter에게_위치데이터를_전달한다() async throws {
        // given
        let spy = UploadPostPresentationLogicSpy()
        sut.presenter = spy

        // when
        sut.fetchCurrentAddress()
        try await Task.sleep(nanoseconds: 3_000_000_000)

        // then
        XCTAssertNotNil(spy.presentCurrentAddressResponse, "fetchCurrentAddress 함수가 presenter에게 위치데이터를 전달하지 못함")
    }

    func test_fetchThumbnailImage를_호출하면_presenter의_presentThumbnailImage가_호출된다() async throws {
        // given
        let spy = UploadPostPresentationLogicSpy()
        sut.presenter = spy
        sut.videoURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8")

        // when
        sut.fetchThumbnailImage()
        try await Task.sleep(nanoseconds: 5_000_000_000)

        // then
        XCTAssertTrue(spy.presentThumbnailCalled, "fetchThumbnailImage 함수가 presentThumbnailImage을 호출하지 못함")
    }

    func test_editTags를_호출하면_datastore에_tags데이터가_전달된다() {
        // given
        let spy = UploadPostPresentationLogicSpy()
        sut.presenter = spy
        let request = UploadPostModels.EditTags.Request(tags: [])

        // when
        sut.editTags(with: request)

        // then
        XCTAssertNotNil(sut.tags, "editTags 함수가 datastore의 tags 데이터를 전달하지 못함")
    }

    func test_title이_nil일때_canUploadPost를_호출하면_presenter의_presentUploadButtonCalled가_호출된다() {
        // given
        let spy = UploadPostPresentationLogicSpy()
        sut.presenter = spy
        let request = UploadPostModels.CanUploadPost.Request(title: nil)

        // when
        sut.canUploadPost(request: request)

        // then
        XCTAssertTrue(spy.presentUploadButtonCalled, "title이 nil일 때 canUploadPost 함수가 presentUploadButton을 호출하지 못함")
    }

    func test_title이_nil이아닐때_canUploadPost를_호출하면_presenter의_presentUploadButtonCalled가_호출된다() {
        // given
        let spy = UploadPostPresentationLogicSpy()
        sut.presenter = spy
        let request = UploadPostModels.CanUploadPost.Request(title: "아아아아")

        // when
        sut.canUploadPost(request: request)

        // then
        XCTAssertTrue(spy.presentUploadButtonCalled, "title이 nil이 아닐 때 canUploadPost 함수가 presentUploadButton을 호출하지 못함")
    }

    func test_title이_nil일때_canUploadPost를_호출하면_올바른결과가_presenter에_전달된다() {
        // given
        let spy = UploadPostPresentationLogicSpy()
        sut.presenter = spy
        let request = UploadPostModels.CanUploadPost.Request(title: nil)

        // when
        sut.canUploadPost(request: request)

        // then
        XCTAssertEqual(spy.presentUploadButtonResponse.isEmpty, true, "title이 nil일 때 canUploadPost 함수가 올바른 결과를 전달하지 못함")
    }

    func test_title이_nil이아닐때_canUploadPost를_호출하면_올바른결과가_presenter에_전달된다() {
        // given
        let spy = UploadPostPresentationLogicSpy()
        sut.presenter = spy
        let request = UploadPostModels.CanUploadPost.Request(title: "아아아아")

        // when
        sut.canUploadPost(request: request)

        // then
        XCTAssertEqual(spy.presentUploadButtonResponse.isEmpty, false, "title이 nil이 아닐 때 canUploadPost 함수가 올바른 결과를 전달하지 못함")
    }

}
