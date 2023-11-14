//
//  Keychain.swift
//  Layover
//
//  Created by 김인환 on 11/13/23.
//

import Foundation

@propertyWrapper struct KeychainStored<Value: Codable> {

    private let securityClass = kSecClassGenericPassword
    private let service: String = Bundle.main.bundleIdentifier ?? "kr.codesquad.boostcamp8.Layover"
    private let key: String

    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private var searchQuery: [String: Any] {
        [
            kSecClass as String: securityClass,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
    }

    var wrappedValue: Value? {
        get {
            valueFromKeychain()
        }
        set {
            storeValueInKeychain(newValue)
        }
    }

    init(key: String) {
        self.key = key
    }

    private func valueFromKeychain() -> Value? {
        var searchQuery = searchQuery

        searchQuery[kSecReturnAttributes as String] = true
        searchQuery[kSecReturnData as String] = true

        var unknownItem: CFTypeRef?
        let status = SecItemCopyMatching(searchQuery as CFDictionary, &unknownItem)

        guard status != errSecItemNotFound else {
            return nil
        }

        guard status == errSecSuccess else {
            // error
            return nil
        }

        guard let item = unknownItem as? [String: Any],
            let data = item[kSecValueData as String] as? Data else {
            // error
                return nil
        }

        return decodeValue(from: data)
    }

    private func decodeValue(from data: Data) -> Value? {
        if Value.self == String.self {
            return String(data: data, encoding: .utf8) as! Value?
        } else {
            do {
                return try self.decoder.decode(Value.self, from: data)
            } catch {
                // error
                return nil
            }
        }
    }
    
    private func storeValueInKeychain(_ value: Value?) {
        guard let encodedValue = encode(value) else {
            deleteFromKeychain()
            return
        }

        let attributes: [String: Any] = [
            kSecValueData as String: encodedValue
        ]

        var status = updateValueInKeychain(encodedValue, attributes: attributes)

        if status == errSecItemNotFound {
            status = addValueInKeychain(encodedValue, attributes: attributes)
        }

        guard status == errSecSuccess else {
            // error
            return
        }
    }

    private func updateValueInKeychain(_ value: Data, attributes: [String: Any]) -> Int32 {
        return SecItemUpdate(searchQuery as CFDictionary, attributes as CFDictionary)
    }

    private func addValueInKeychain(_ value: Data, attributes: [String: Any]) -> Int32 {
        let addQuery = searchQuery.merging(attributes, uniquingKeysWith: { (_, new) in new })
        return SecItemAdd(addQuery as CFDictionary, nil)
    }

    private func encode(_ value: Value?) -> Data? {
        guard let value = value else {
            return nil
        }

        if Value.self == String.self {
            let string = value as! String
            return Data(string.utf8)
        } else {
            do {
                return try encoder.encode(value)
            } catch {
                // error
                return nil
            }
        }
    }

    private func deleteFromKeychain() {
        let status = SecItemDelete(searchQuery as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            return
        }
    }
}
