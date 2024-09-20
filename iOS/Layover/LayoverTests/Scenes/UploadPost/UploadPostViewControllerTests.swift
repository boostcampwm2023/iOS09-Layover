//
//  UploadPostViewControllerTests.swift
//  LayoverTests
//
//  Created by kong on 2023/12/12.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

@testable import Layover
import XCTest

class UploadPostViewControllerTests: XCTestCase {

    // MARK: - Subject Under Test (SUT)

    typealias Models = UploadPostModels
    var sut: UploadPostViewController!
    var window: UIWindow!

    // MARK: - Test Lifecycle

    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupUploadPostViewController()
    }

    override func tearDown() {
        window = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Test Setup

    func setupUploadPostViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "UploadPostViewController") as? UploadPostViewController
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
//
//    // MARK: - Test Doubles
//
//    class UploadPostBusinessLogicSpy: UploadPostBusinessLogic {
//
//        // MARK: Spied Methods
//
//        var fetchFromLocalDataStoreCalled = false
//        func fetchFromLocalDataStore(with request: UploadPostModels.FetchFromLocalDataStore.Request) {
//            fetchFromLocalDataStoreCalled = true
//        }
//
//        var fetchFromRemoteDataStoreCalled = false
//        func fetchFromRemoteDataStore(with request: UploadPostModels.FetchFromRemoteDataStore.Request) {
//            fetchFromRemoteDataStoreCalled = true
//        }
//
//        var trackAnalyticsCalled = false
//        func trackAnalytics(with request: UploadPostModels.TrackAnalytics.Request) {
//            trackAnalyticsCalled = true
//        }
//
//        var performUploadPostCalled = false
//        func performUploadPost(with request: UploadPostModels.PerformUploadPost.Request) {
//            performUploadPostCalled = true
//        }
//    }
//
//    class UploadPostRouterSpy: UploadPostRouter {
//
//        // MARK: Spied Methods
//
//        var routeToNextCalled = false
//        override func routeToNext() {
//            routeToNextCalled = true
//        }
//    }
//
//    // MARK: - Tests
//
//    func testShouldFetchFromLocalDataStoreWhenViewIsLoaded() {
//        // given
//        let spy = UploadPostBusinessLogicSpy()
//        sut.interactor = spy
//
//        // when
//        loadView()
//
//        // then
//        XCTAssertTrue(spy.fetchFromLocalDataStoreCalled, "viewDidLoad() should ask the interactor to fetch from local DataStore")
//    }
//
//    func testShouldDisplayDataFetchedFromLocalDataStore() {
//        // given
//        loadView()
//        let translation = "Example string."
//        let viewModel = Models.FetchFromLocalDataStore.ViewModel(exampleTranslation: translation)
//
//        // when
//        sut.displayFetchFromLocalDataStore(with: viewModel)
//
//        // then
//        XCTAssertEqual(sut.exampleLocalLabel.text, translation, "displayFetchFromLocalDataStore(with:) should display the correct example label text")
//    }
//
//    func testShouldFetchFromRemoteDataStoreWhenViewWillAppear() {
//        // given
//        let spy = UploadPostBusinessLogicSpy()
//        sut.interactor = spy
//
//        // when
//        loadView()
//
//        // then
//        XCTAssertTrue(spy.fetchFromRemoteDataStoreCalled, "viewWillAppear(_:) should ask the interactor to fetch from remote DataStore")
//    }
//
//    func testShouldDisplayDataFetchedFromRemoteDataStore() {
//        // given
//        loadView()
//        let exampleVariable = "Example string."
//        let viewModel = Models.FetchFromRemoteDataStore.ViewModel(exampleVariable: exampleVariable)
//
//        // when
//        sut.displayFetchFromRemoteDataStore(with: viewModel)
//
//        // then
//        XCTAssertEqual(sut.exampleRemoteLabel.text, exampleVariable, "displayFetchFromRemoteDataStore(with:) should display the correct example label text")
//    }
//
//    func testShouldTrackAnalyticsWhenViewDidAppear() {
//        // given
//        let spy = UploadPostBusinessLogicSpy()
//        sut.interactor = spy
//        loadView()
//
//        // when
//        sut.viewDidAppear(true)
//
//        // then
//        XCTAssertTrue(spy.trackAnalyticsCalled, "When needed, view controller should ask the interactor to track analytics")
//    }
//
//    func testShouldDisplayTrackAnalyticsWhenDisplayTrackAnalytics() {
//        // given
//        loadView()
//        let viewModel = Models.TrackAnalytics.ViewModel()
//
//        // when
//        sut.displayTrackAnalytics(with: viewModel)
//
//        // then
//        // assert something here based on use case
//    }
//
//    func testUnsuccessfulUploadPostShouldShowErrorAsLabel() {
//        // given
//        loadView()
//        var error = Models.UploadPostError(type: .emptyExampleVariable)
//        error.message = "Example error"
//        let viewModel = Models.PerformUploadPost.ViewModel(error: error)
//
//        // when
//        sut.displayPerformUploadPost(with: viewModel)
//
//        // then
//        XCTAssertEqual(sut.exampleLocalLabel.text, error.message, "displayPerformUploadPost(with:) should set error as label if there is an error")
//    }
//
//    func testUnsuccessfulUploadPostShouldNotRouteToNext() {
//        // given
//        let spy = UploadPostRouterSpy()
//        sut.router = spy
//        loadView()
//        let error = UploadPostModels.Error<UploadPostModels.UploadPostErrorType>.init(type: .emptyExampleVariable)
//        let viewModel = UploadPostModels.PerformUploadPost.ViewModel(error: error)
//
//        // when
//        sut.displayPerformUploadPost(with: viewModel)
//
//        // then
//        XCTAssertFalse(spy.routeToNextCalled, "displayPerformUploadPost(with:) should not route to next screen if there is an error")
//    }
//
//    func testSuccessfulUploadPostShouldRouteToNext() {
//        // given
//        let spy = UploadPostRouterSpy()
//        sut.router = spy
//        loadView()
//        let viewModel = UploadPostModels.PerformUploadPost.ViewModel(error: nil)
//
//        // when
//        sut.displayPerformUploadPost(with: viewModel)
//
//        // then
//        XCTAssertTrue(spy.routeToNextCalled, "displayPerformUploadPost(with:) should route to next screen if there is no error")
//    }
}
