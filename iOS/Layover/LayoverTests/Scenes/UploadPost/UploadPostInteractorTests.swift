//
//  UploadPostInteractorTests.swift
//  LayoverTests
//
//  Created by kong on 2023/12/12.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

@testable import Layover
import XCTest

//class UploadPostInteractorTests: XCTestCase {
//
//    // MARK: - Subject Under Test (SUT)
//
//    typealias Models = UploadPostModels
//    var sut: UploadPostInteractor!
//
//    // MARK: - Test Lifecycle
//
//    override func setUp() {
//        super.setUp()
//        setupUploadPostInteractor()
//    }
//
//    override func tearDown() {
//        sut = nil
//        super.tearDown()
//    }
//
//    // MARK: - Test Setup
//
//    func setupUploadPostInteractor() {
//        sut = UploadPostInteractor()
//    }
//
//    // MARK: - Test Doubles
//
//    class UploadPostPresentationLogicSpy: UploadPostPresentationLogic {
//
//        // MARK: Spied Methods
//
//        var presentFetchFromLocalDataStoreCalled = false
//        var fetchFromLocalDataStoreResponse: UploadPostModels.FetchFromLocalDataStore.Response!
//        func presentFetchFromLocalDataStore(with response: UploadPostModels.FetchFromLocalDataStore.Response) {
//            presentFetchFromLocalDataStoreCalled = true
//            fetchFromLocalDataStoreResponse = response
//        }
//
//        var presentFetchFromRemoteDataStoreCalled = false
//        var fetchFromRemoteDataStoreResponse: UploadPostModels.FetchFromRemoteDataStore.Response!
//        func presentFetchFromRemoteDataStore(with response: UploadPostModels.FetchFromRemoteDataStore.Response) {
//            presentFetchFromRemoteDataStoreCalled = true
//            fetchFromRemoteDataStoreResponse = response
//        }
//
//        var presentTrackAnalyticsCalled = false
//        var trackAnalyticsResponse: UploadPostModels.TrackAnalytics.Response!
//        func presentTrackAnalytics(with response: UploadPostModels.TrackAnalytics.Response) {
//            presentTrackAnalyticsCalled = true
//            trackAnalyticsResponse = response
//        }
//
//        var presentPerformUploadPostCalled = false
//        var performUploadPostResponse: UploadPostModels.PerformUploadPost.Response!
//        func presentPerformUploadPost(with response: UploadPostModels.PerformUploadPost.Response) {
//            presentPerformUploadPostCalled = true
//            performUploadPostResponse = response
//        }
//    }
//
//    class UploadPostWorkerSpy: UploadPostWorker {
//
//        // MARK: Spied Methods
//
//        var validateExampleVariableCalled = false
//        override func validate(exampleVariable: String?) -> Models.UploadPostError? {
//            validateExampleVariableCalled = true
//            return super.validate(exampleVariable: exampleVariable)
//        }
//    }
//
//    // MARK: - Tests
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
//}
