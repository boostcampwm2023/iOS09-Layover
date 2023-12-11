//
//  UserDefaultStored.swift
//  Layover
//
//  Created by 김인환 on 11/26/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefaultStored<T: Codable> {
    private let key: String
    private let defaultValue: T?

    init(key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T? {
        get {
            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let loadedObject = try? decoder.decode(T.self, from: savedData) {
                    return loadedObject
                }
            }
            return defaultValue
        }
        set {
            let encoder = JSONEncoder()
            if let encodedObject = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encodedObject, forKey: key)
            }
        }
    }
}

enum UserDefaultKey {
    static let isLoggedIn = "isLoggedIn"
    static let hasBeenLaunchedBefore = "hasBeenLaunchedBefore"
    static let memberId = "memberId"
}
