//
//  StubAuthManager.swift
//  LayoverTests
//
//  Created by 김인환 on 12/2/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//
@testable import Layover
import Foundation

class StubAuthManager: AuthManagerProtocol {

    // MARK: - Properties

    var accessToken: String? = "Fake Access Token"
    var refreshToken: String? = "Fake Refresh Token"
    var isLoggedIn: Bool? = true
    var loginType: LoginType? = .kakao
    var memberID: Int? = -1

    // MARK: - Methods

    func login(accessToken: String?, refreshToken: String?, loginType: LoginType?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
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
