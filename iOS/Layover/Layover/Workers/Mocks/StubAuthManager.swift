//
//  StubAuthManager.swift
//  Layover
//
//  Created by 김인환 on 12/2/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

final class StubAuthManager: AuthManagerProtocol {

    // MARK: Properties

    var accessToken: String? = "Fake Access Token"
    var refreshToken: String? = "Fake Refresh Token"
    var isLoggedIn: Bool? = true
    var loginType: LoginType? = .kakao
    var memberID: Int? = -1
}
