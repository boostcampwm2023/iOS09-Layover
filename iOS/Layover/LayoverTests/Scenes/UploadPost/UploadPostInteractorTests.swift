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
        sut = UploadPostInteractor(locationManager: CurrentLocationManager())
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
        XCTAssertTrue(spy.presentTagCalled, "")
    }

    func test_fetchTags를_호출하면_datastore에_tags데이터가_전달된다() {
        // given
        let spy = UploadPostPresentationLogicSpy()
        sut.presenter = spy

        // when
        sut.fetchTags()

        // then
        XCTAssertNotNil(sut.tags)
    }

    func test_fetchCurrentAddress를_호출하면_presenter의_presentTags가_호출된다() {
        // given
        let spy = UploadPostPresentationLogicSpy()
        sut.presenter = spy

        // when
        sut.fetchCurrentAddress()

        // then
        XCTAssertTrue(spy.presentCurrentAddressCalled, "")
    }

    func test_fetchCurrentAddress를_호출하면_presenter에게_올바른데이터를_전달한다() {
        // given
        let spy = UploadPostPresentationLogicSpy()
        sut.presenter = spy

        // when
        sut.fetchCurrentAddress()

        // then
//        XCTAssertTrue(spy.presentCurrentAddressResponse, "")
    }

    func test_fetchThumbnailImage를_호출하면_presenter의_presentThumbnailImage가_호출된다() {
        // given
        let spy = UploadPostPresentationLogicSpy()
        sut.presenter = spy

        // when
        sut.fetchThumbnailImage()

        // then
        XCTAssertTrue(spy.presentThumbnailCalled, "")
    }

    func test_editTags를_호출하면_presenter의_presentThumbnailImage가_호출된다() {
        // given
        let spy = UploadPostPresentationLogicSpy()
        sut.presenter = spy
        let request = UploadPostModels.EditTags.Request(tags: [])

        // when
        sut.editTags(with: request)

        // then
        XCTAssertTrue(spy.presentThumbnailCalled, "")
    }

    func test_canUploadPost를_호출하면_presenter의_presentThumbnailImage가_호출된다() {
        // given
        let spy = UploadPostPresentationLogicSpy()
        sut.presenter = spy
        let request = UploadPostModels.CanUploadPost.Request(title: <#T##String?#>)

        // when
        sut.canUploadPost(request: request)

        // then
        XCTAssertTrue(spy.presentThumbnailCalled, "")
    }

    func test_uploadPost를_호출하면_presenter의_presentThumbnailImage가_호출된다() {
        // given
        let spy = UploadPostPresentationLogicSpy()
        sut.presenter = spy
        let request = UploadPostModels.UploadPost.Request(title: <#T##String#>,
                                                          content: <#T##String?#>,
                                                          tags: <#T##[String]#>)

        // when
        sut.uploadPost(request: request)

        // then
        XCTAssertTrue(spy.presentThumbnailCalled, "")
    }

//
//    func testFetchFromLocalDataStoreShouldAskPresenterToFormat() {
//        // given
//        let spy = UploadPostPresentationLogicSpy()
//        sut.presenter = spy
//        let request = Models.FetchFromLocalDataStore.Request()
//
//        // when
//        sut.fetchFromLocalDataStore(with: request)
//
//        // then
//        XCTAssertTrue(spy.presentFetchFromLocalDataStoreCalled, "fetchFromLocalDataStore(with:) should ask the presenter to format the result")
//    }
//
//    func testTrackAnalyticsShouldAskPresenterToFormat() {
//        // given
//        let spy = UploadPostPresentationLogicSpy()
//        sut.presenter = spy
//        let request = Models.TrackAnalytics.Request(event: .screenView)
//
//        // when
//        sut.trackAnalytics(with: request)
//
//        // then
//        XCTAssertTrue(spy.presentTrackAnalyticsCalled, "trackAnalytics(with:) should ask the presenter to format the result")
//    }
//
//    func testPerformUploadPostShouldValidateExampleVariable() {
//        // given
//        let spy = UploadPostWorkerSpy()
//        sut.worker = spy
//        let request = Models.PerformUploadPost.Request()
//
//        // when
//        sut.performUploadPost(with: request)
//
//        // then
//        XCTAssertTrue(spy.validateExampleVariableCalled, "performUploadPost(with:) should ask the worker to validate the example variable")
//    }
//
//    func testPerformUploadPostShouldAskPresenterToFormat() {
//        // given
//        let spy = UploadPostPresentationLogicSpy()
//        sut.presenter = spy
//        let request = Models.PerformUploadPost.Request()
//
//        // when
//        let expect = expectation(description: "Wait for performUploadPost(with:) to return")
//        sut.performUploadPost(with: request)
//        expect.fulfill()
//        waitForExpectations(timeout: 1)
//
//        // then
//        XCTAssertTrue(spy.presentPerformUploadPostCalled, "performUploadPost(with:) should ask the presenter to format the result")
//    }
}
