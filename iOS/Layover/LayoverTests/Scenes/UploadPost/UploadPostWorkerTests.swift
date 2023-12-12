//
//  UploadPostWorkerTests.swift
//  LayoverTests
//
//  Created by kong on 2023/12/12.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

@testable import Layover
import XCTest

//class UploadPostWorkerTests: XCTestCase {
//
//    // MARK: - Subject Under Test (SUT)
//
//    typealias Models = UploadPostModels
//    var sut: UploadPostWorker!
//
//    // MARK: - Test Lifecycle
//
//    override func setUp() {
//        super.setUp()
//        setupUploadPostWorker()
//    }
//
//    override func tearDown() {
//        sut = nil
//        super.tearDown()
//    }
//
//    // MARK: - Test Setup
//
//    func setupUploadPostWorker() {
//        sut = UploadPostWorker()
//    }
//
//    // MARK: - Test Doubles
//
//    // MARK: - Tests
//
//    func testValidateExampleVariableShouldCreateEmptyExampleVariableErrorIfExampleVariableIsNil() {
//        // given
//        let exampleVariable: String? = nil
//
//        // when
//        let error = sut.validate(exampleVariable: exampleVariable)
//
//        // then
//        XCTAssertNotNil(error, "validate(exampleVariable:) should create an error if example variable is nil")
//        XCTAssertEqual(error?.type, Models.UploadPostErrorType.emptyExampleVariable, "validate(exampleVariable:) should create an emptyExampleVariable error if example variable is nil")
//    }
//
//    func testValidateExampleVariableShouldCreateEmptyExampleVariableErrorIfExampleVariableIsEmpty() {
//        // given
//        let exampleVariable = ""
//
//        // when
//        let error = sut.validate(exampleVariable: exampleVariable)
//
//        // then
//        XCTAssertNotNil(error, "validate(exampleVariable:) should create an error if example variable is empty")
//        XCTAssertEqual(error?.type, Models.UploadPostErrorType.emptyExampleVariable, "validate(exampleVariable:) should create an emptyExampleVariable error if example variable is empty")
//    }
//
//    func testValidateExampleVariableShouldNotCreateErrorIfExampleVariableIsNotNilOrEmpty() {
//        // given
//        let exampleVariable = "Example string."
//
//        // when
//        let error = sut.validate(exampleVariable: exampleVariable)
//
//        // then
//        XCTAssertNil(error, "validate(exampleVariable:) should not create an error if example variable is not nil or empty")
//    }
//}
