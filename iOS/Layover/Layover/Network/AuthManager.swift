//
//  AuthManager.swift
//  Layover
//
//  Created by 김인환 on 11/13/23.
//

protocol AuthManagerProtocol {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
}

final class AuthManager: AuthManagerProtocol {

    // MARK: Properties

    @KeychainStored(key: "accessToken") var accessToken: String?
    @KeychainStored(key: "refreshToken") var refreshToken: String?

    @UserDefaultStored(key: UserDefaultKey.isLoggedIn, defaultValue: false) var isLoggedIn: Bool

    static let shared = AuthManager()

    private init() { }
}
