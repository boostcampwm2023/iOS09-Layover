//
//  Keychain.swift
//  Layover
//
//  Created by 김인환 on 11/13/23.
//

import Foundation

@propertyWrapper struct Keychain {

    private let key: String

    init(key: String) {
        self.key = key
    }

    var wrappedValue: String? {
        get {
            KeychainManager.shared.read(account: key)
        }

        set {
            guard let newValue else { return }
            KeychainManager.shared.create(account: key, value: newValue)
        }
    }
}

final class KeychainManager {

    static let shared = KeychainManager()

    private let serviceIdentifier: String = Bundle.main.bundleIdentifier ?? ""

    func create(account: String, value: String) {
        let keyChainQuery: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService: serviceIdentifier,
            kSecAttrAccount: account,
            kSecValueData: value.data(using: .utf8, allowLossyConversion: false)!
        ]

        SecItemDelete(keyChainQuery)

        let status: OSStatus = SecItemAdd(keyChainQuery, nil)
        assert(status == noErr, "failed to saving Token")
    }

    func read(account: String) -> String? {
        let KeyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceIdentifier,
            kSecAttrAccount: account,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(KeyChainQuery, &dataTypeRef)

        if(status == errSecSuccess) {
            let retrievedData = dataTypeRef as! Data
            let value = String(data: retrievedData, encoding: String.Encoding.utf8)
            return value
        } else {
            print("failed to loading, status code = \(status)")
            return nil
        }
    }

    func delete(account: String) {
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceIdentifier,
            kSecAttrAccount: account
        ]

        let status = SecItemDelete(keyChainQuery)
        assert(status == noErr, "failed to delete the value, status code = \(status)")
    }
}
