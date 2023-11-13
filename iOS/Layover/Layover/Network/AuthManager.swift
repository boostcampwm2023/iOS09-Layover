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

    @Keychain(key: "accessToken") var accessToken: String?
    @Keychain(key: "refreshToken") var refreshToken: String?

    static let shared = AuthManager()

    private init() { }
}

//actor AuthManager: AuthManagerProtocol {
//    private var currentToken: Token?
//    private var refreshTask: Task<Token, Error>?
//
//    func validToken() async throws -> Token {
//        if let handle = refreshTask {
//            return try await handle.value
//        }
//
//        guard let token = currentToken else {
//            throw AuthError.missingToken
//        }
//
//        return try await refreshToken()
//    }
//
//    func refreshToken() async throws -> Token {
//        if let refreshTask = refreshTask {
//            return try await refreshTask.value
//        }
//
//        let task = Task { () throws -> Token in
//            defer { refreshTask = nil }
//
//            // Normally you'd make a network call here. Could look like this:
//            // return await networking.refreshToken(withRefreshToken: token.refreshToken)
//
//            // I'm just generating a dummy token
//            let tokenExpiresAt = Date().addingTimeInterval(10)
//            let newToken = Token(validUntil: tokenExpiresAt, id: UUID())
//            currentToken = newToken
//
//            return newToken
//        }
//
//        self.refreshTask = task
//
//        return try await task.value
//    }
//}
//
//enum AuthError: Error {
//    case missingToken
//}
