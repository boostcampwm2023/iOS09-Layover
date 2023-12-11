//
//  AuthManager.swift
//  Layover
//
//  Created by 김인환 on 11/13/23.
//

protocol AuthManagerProtocol: AnyObject {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
    var isLoggedIn: Bool? { get set }
    var memberId: Int? { get set }

    func logout()
}

extension AuthManagerProtocol {
    func logout() {
        accessToken = nil
        refreshToken = nil
        memberId = nil
        isLoggedIn = false
    }
}

final class AuthManager: AuthManagerProtocol {

    // MARK: Properties

    @KeychainStored(key: "accessToken") var accessToken: String?
    @KeychainStored(key: "refreshToken") var refreshToken: String?

    @UserDefaultStored(key: UserDefaultKey.isLoggedIn, defaultValue: false) var isLoggedIn: Bool?
    @UserDefaultStored(key: UserDefaultKey.memberId, defaultValue: nil) var memberId: Int?

    static let shared = AuthManager()

    private init() { }
}
