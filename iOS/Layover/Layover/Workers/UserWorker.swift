//
//  UserWorker.swift
//  Layover
//
//  Created by 김인환 on 11/28/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import OSLog

enum NicknameState {
    case valid
    case lessThan2GreaterThan8
    case invalidCharacter

    var alertDescription: String? {
        switch self {
        case .valid:
            return nil
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
    // func modifyProfileImage() async throws -> URL
    func modifyIntroduce(to introduce: String) async -> String?
    func withdraw() async -> String?

    func fetchProfile(by id: Int?) async -> Member?
    func fetchPosts(at page: Int, of id: Int?) async -> [Post]?
    func fetchImageData(with url: URL) async -> Data?
}

final class UserWorker: UserWorkerProtocol {

    // MARK: - Properties

    private let userEndPointFactory: UserEndPointFactory
    private let provider: ProviderType

    // MARK: - Intializer

    init(userEndPointFactory: UserEndPointFactory = DefaultUserEndPointFactory(),
         provider: ProviderType = Provider()) {
        self.userEndPointFactory = userEndPointFactory
        self.provider = provider
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
            return data.userName
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
            return data.userName
        } catch {
            os_log(.error, log: .default, "Failed to withdraw with error: %@", error.localizedDescription)
            return nil
        }
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

    func fetchPosts(at page: Int, of id: Int?) async -> [Post]? {
        let endPoint = userEndPointFactory.makeUserPostsEndPoint(at: page, of: id)

        do {
            let response = try await provider.request(with: endPoint)
            return response.data?.map { $0.toDomain() }
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
}
