//
//  UserWorker.swift
//  Layover
//
//  Created by 김인환 on 11/28/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import OSLog

enum NicknameState: CustomStringConvertible {
    case valid
    case lessThan2GreaterThan8
    case invalidCharacter

    var description: String {
        switch self {
        case .valid:
            return ""
        case .lessThan2GreaterThan8:
            return "2자 이상 8자 이하로 입력해주세요."
        case .invalidCharacter:
            return "입력할 수 없는 문자입니다."
        }
    }
}

protocol UserWorkerProtocol {
    func validateNickname(_ nickname: String) -> NicknameState
    func modifyNickname(to nickname: String) async -> String?
    func checkNotDuplication(for userName: String) async -> Bool?
    func modifyProfileImage(data: Data, contentType: String, to url: String) async -> Bool
    func modifyIntroduce(to introduce: String) async -> String?
    func withdraw() async -> String?
    func logout()

    func fetchProfile(by id: Int?) async -> Member?
    func fetchPosts(at cursor: Int?, of id: Int?) async -> PostsPage?
    func fetchImageData(with url: URL) async -> Data?
    func setProfileImageDefault() async -> Bool
    func fetchImagePresignedURL(with fileType: String) async -> String?
}

class UserWorker: UserWorkerProtocol {

    // MARK: - Properties

    private let userEndPointFactory: UserEndPointFactory
    private let provider: ProviderType
    private let authManager: AuthManagerProtocol

    // MARK: - Intializer

    init(userEndPointFactory: UserEndPointFactory = DefaultUserEndPointFactory(),
         provider: ProviderType = Provider(),
         authManager: AuthManagerProtocol = AuthManager.shared) {
        self.userEndPointFactory = userEndPointFactory
        self.provider = provider
        self.authManager = authManager
    }

    // MARK: - Methods

    func validateNickname(_ nickname: String) -> NicknameState {
        if nickname.count < 2 || nickname.count > 8 {
            return .lessThan2GreaterThan8
        } else if nickname.wholeMatch(of: /^[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣]+/) == nil {
            return .invalidCharacter
        }
        return .valid
    }

    func modifyNickname(to nickname: String) async -> String? {
        let endPoint = userEndPointFactory.makeUserNameModifyEndPoint(userName: nickname)
        do {
            let responseData = try await provider.request(with: endPoint)
            guard let data = responseData.data else {
                os_log(.error, log: .default, "Failed to modify nickname with error: %@", responseData.message)
                return nil
            }
            return data.username
        } catch {
            os_log(.error, log: .default, "Failed to modify nickname with error: %@", error.localizedDescription)
            return nil
        }
    }

    func checkNotDuplication(for userName: String) async -> Bool? {
        let endPoint = userEndPointFactory.makeUserNameIsNotDuplicateEndPoint(of: userName)
        do {
            let responseData = try await provider.request(with: endPoint, authenticationIfNeeded: false)
            return responseData.data?.isValid
        } catch {
            os_log(.error, log: .default, "Failed to check duplicate username with error: %@", error.localizedDescription)
            return false
        }
    }

    func modifyProfileImage(data: Data, contentType: String, to url: String) async -> Bool {
        do {
            let responseData = try await provider.upload(data: data, contentType: contentType, to: url)
            return true
        } catch {
            os_log(.error, log: .default, "Failed to modify profile image with error: %@", error.localizedDescription)
            return false
        }
    }

    func modifyIntroduce(to introduce: String) async -> String? {
        let endPoint = userEndPointFactory.makeIntroduceModifyEndPoint(introduce: introduce)
        do {
            let responseData = try await provider.request(with: endPoint)
            guard let data = responseData.data else {
                os_log(.error, log: .default, "Failed to modify introduce with error: %@", responseData.message)
                return nil
            }
            return data.introduce
        } catch {
            os_log(.error, log: .default, "Failed to modify introduce with error: %@", error.localizedDescription)
            return nil
        }
    }

    func withdraw() async -> String? {
        let endPoint = userEndPointFactory.makeUserWithDrawEndPoint()
        do {
            let responseData = try await provider.request(with: endPoint)
            guard let data = responseData.data else {
                os_log(.error, log: .default, "Failed to withdraw with error: %@", responseData.message)
                return nil
            }
            return data.username
        } catch {
            os_log(.error, log: .default, "Failed to withdraw with error: %@", error.localizedDescription)
            return nil
        }
    }

    func logout() {
        authManager.logout()
    }

    func fetchProfile(by id: Int?) async -> Member? {
        let endPoint = userEndPointFactory.makeUserInformationEndPoint(with: id)

        do {
            let response = try await provider.request(with: endPoint)
            return response.data?.toDomain()
        } catch {
            os_log(.error, log: .data, "Error: %s", error.localizedDescription)
            return nil
        }
    }

    func fetchPosts(at cursor: Int?, of id: Int?) async -> PostsPage? {
        let endPoint = userEndPointFactory.makeUserPostsEndPoint(at: cursor, of: id)

        do {
            let response = try await provider.request(with: endPoint)
            return response.data?.toDomain()
        } catch {
            os_log(.error, log: .data, "Error: %s", error.localizedDescription)
            return nil
        }
    }

    func fetchImageData(with url: URL) async -> Data? {
        do {
            return try await provider.request(url: url)
        } catch {
            os_log(.error, log: .data, "Error: %s", error.localizedDescription)
            return nil
        }
    }

    func setProfileImageDefault() async -> Bool {
        let endPoint = userEndPointFactory.makeUserProfileImageDefaultEndPoint()

        do {
            _ = try await provider.request(with: endPoint)
            return true
        } catch {
            os_log(.error, log: .data, "Error: %s", error.localizedDescription)
            return false
        }
    }

    func fetchImagePresignedURL(with fileType: String) async -> String? {
        do {
            let endPoint = userEndPointFactory.makeFetchUserProfilePresignedURL(of: fileType)
            return try await provider.request(with: endPoint).data?.preSignedURL
        } catch {
            os_log(.error, log: .data, "Error: %s", error.localizedDescription)
            return nil
        }
    }
}
