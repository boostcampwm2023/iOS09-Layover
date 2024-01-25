//
//  UploadPostPresenterTests.swift
//  LayoverTests
//
//  Created by kong on 2023/12/12.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

@testable import Layover
import XCTest

class UploadPostPresenterTests: XCTestCase {

    // MARK: - Subject Under Test (SUT)

    typealias Models = UploadPostModels
    var sut: UploadPostPresenter!

    // MARK: - Test Lifecycle

    override func setUp() {
        super.setUp()
        setupUploadPostPresenter()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Test Setup

    func setupUploadPostPresenter() {
        sut = UploadPostPresenter()
    }

    // MARK: - Test Doubles

    class UploadPostDisplayLogicSpy: UploadPostDisplayLogic {

        // MARK: Spied Methods

        var displayTagsCalled = false
        var displayTagsViewModel: UploadPostModels.FetchTags.ViewModel!
        func displayTags(viewModel: Layover.UploadPostModels.FetchTags.ViewModel) {
            displayTagsCalled = true
            displayTagsViewModel = viewModel

        }

        var displayThumbnailCalled = false
        var displayThumbnailViewModel: UploadPostModels.FetchThumbnail.ViewModel!
        func displayThumbnail(viewModel: Layover.UploadPostModels.FetchThumbnail.ViewModel) {
            displayThumbnailCalled = true
            displayThumbnailViewModel = viewModel
        }

        var displayCurrentAddressCalled = false
        var displayCurrentAddressViewModel: UploadPostModels.FetchCurrentAddress.ViewModel!
        func displayCurrentAddress(viewModel: Layover.UploadPostModels.FetchCurrentAddress.ViewModel) {
            displayCurrentAddressCalled = true
            displayCurrentAddressViewModel = viewModel
        }

        var displayUploadButtonCalled = false
        var displayUploadButtonViewModel: UploadPostModels.CanUploadPost.ViewModel!
        func displayUploadButton(viewModel: Layover.UploadPostModels.CanUploadPost.ViewModel) {
            displayUploadButtonCalled = true
            displayUploadButtonViewModel = viewModel
        }

        func displayUnsupportedFormatAlert() {

        }

    }

    // MARK: - Tests

    func test_presentTags를_호출하면_displayTags를_호출한다() {
        // given
        let spy = UploadPostDisplayLogicSpy()
        sut.viewController = spy
        let response = Models.FetchTags.Response(tags: [])

        // when
        sut.presentTags(with: response)

        // then
        XCTAssertTrue(spy.displayTagsCalled, "presentTags(with:) 함수가 displayTags를 호출하지 못함")
    }

    func test_presentThumbnail을_호출하면_displayThumbnail을_호출한다() {
        // given
        let spy = UploadPostDisplayLogicSpy()
        sut.viewController = spy
        let thumbnailImage = UIImage(resource: .content).cgImage!
        let response = Models.FetchThumbnail.Response(thumbnailImage: thumbnailImage)

        // when
        sut.presentThumbnailImage(with: response)

        // then
        XCTAssertTrue(spy.displayThumbnailCalled, "presentThumbnailImage(with:) 함수가 displayThumbnail을 호출하지 못함")
    }

    func test_presentCurrentAddress를_호출하면_displayCurrentAddress를_호출한다() {
        // given
        let spy = UploadPostDisplayLogicSpy()
        sut.viewController = spy
        let response = Models.FetchCurrentAddress.Response(addressInfo: [Models.AddressInfo(
            administrativeArea: nil,
            locality: nil,
            subLocality: nil)])

        // when
        sut.presentCurrentAddress(with: response)

        // then
        XCTAssertTrue(spy.displayCurrentAddressCalled, "presentCurrentAddress(with:) 함수가 displayCurrentAddress을 호출하지 못함")
    }

    func test_presentUploadButton를_호출하면_displayUploadButton을_호출한다() {
        // given
        let spy = UploadPostDisplayLogicSpy()
        sut.viewController = spy
        let response = Models.CanUploadPost.Response(isEmpty: true)

        // when
        sut.presentUploadButton(with: response)

        // then
        XCTAssertTrue(spy.displayUploadButtonCalled, "presentUploadButton(with:) 함수가 displayUploadButton을 호출하지 못함")
    }

}
