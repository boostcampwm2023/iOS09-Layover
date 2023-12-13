//
//  MockSettingWorker.swift
//  LayoverTests
//
//  Created by 김인환 on 12/13/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//
@testable import Layover
import Foundation

final class MockSettingWorker: SettingWorkerProtocol {

    // MARK: - Methods
    
    func versionNumber() -> String? {
        "7.7.7"
    }
}
