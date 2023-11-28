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
    func modifyNickname(to nickname: String) async throws -> String?
    func checkDuplication(for userName: String) async throws -> Bool
    // TODO: multipart request 구현
    // func modifyProfileImage() async throws -> URL
    func modifyIntroduce(to introduce: String) async throws -> String?
    func withdraw() async throws -> String?
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

    func modifyNickname(to nickname: String) async throws -> String? {
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

    func checkDuplication(for userName: String) async throws -> Bool {
        let endPoint = userEndPointFactory.makeUserNameIsDuplicateEndPoint(of: userName)
        do {
            let responseData = try await provider.request(with: endPoint, authenticationIfNeeded: false)
            guard let data = responseData.data else {
                os_log(.error, log: .default, "Failed to check duplicate username with error: %@", responseData.message)
                return false
            }
            return data.isValid
        } catch {
            os_log(.error, log: .default, "Failed to check duplicate username with error: %@", error.localizedDescription)
            return false
        }
    }

    func modifyIntroduce(to introduce: String) async throws -> String? {
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

    func withdraw() async throws -> String? {
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
}
