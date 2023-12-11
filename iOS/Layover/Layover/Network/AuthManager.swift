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
    var loginType: LoginType? { get set }
    var memberID: Int? { get set }

    func login(accessToken: String?, refreshToken: String?, memberID: Int?, loginType: LoginType?)
    func logout()
}

enum LoginType: String, Codable {
    case kakao
    case apple
}

extension AuthManagerProtocol {
    func login(accessToken: String?, refreshToken: String?, memberID: Int?, loginType: LoginType?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.memberID = memberID
        self.loginType = loginType
        isLoggedIn = true
    }

    func logout() {
        accessToken = nil
        refreshToken = nil
        memberID = nil
        loginType = nil
        isLoggedIn = false
    }
}

final class AuthManager: AuthManagerProtocol {

    // MARK: Properties

    @KeychainStored(key: "accessToken") var accessToken: String?
    @KeychainStored(key: "refreshToken") var refreshToken: String?

    @UserDefaultStored(key: UserDefaultKey.isLoggedIn, defaultValue: false) var isLoggedIn: Bool?
    @UserDefaultStored(key: UserDefaultKey.memberId, defaultValue: nil) var memberID: Int?
    @UserDefaultStored(key: UserDefaultKey.loginType, defaultValue: nil) var loginType: LoginType?

    static let shared = AuthManager()

    private init() { }
}
