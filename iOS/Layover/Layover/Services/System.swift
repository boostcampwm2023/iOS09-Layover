//
//  System.swift
//  Layover
//
//  Created by 김인환 on 12/1/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

enum System {

    @UserDefaultStored(key: UserDefaultKey.hasBeenLaunchedBefore, defaultValue: false) static var hasBeenLaunchedBefore: Bool

    static func isFirstLaunch() -> Bool {
        if !hasBeenLaunchedBefore {
            hasBeenLaunchedBefore = true
            return true
        }
        return false
    }

    static func versionNumber() -> String? {
        guard let info = Bundle.main.infoDictionary,
              let currentVersion = info["CFBundleShortVersionString"] as? String else { return nil }
        return currentVersion
    }
}
