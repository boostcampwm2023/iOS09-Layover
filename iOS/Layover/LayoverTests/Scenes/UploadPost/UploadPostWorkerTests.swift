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
        sut = UploadPostWorker()
    }

}
