//
//  UserWorker.swift
//  Layover
//
//  Created by 김인환 on 11/28/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import OSLog

protocol UserWorkerProtocol {
    func modifyNickname(to nickname: String) async throws -> String
    func checkDuplication(for userName: String) async throws -> Bool
    // TODO: multipart request 구현
    // func modifyProfileImage() async throws -> URL
    func modifyIntroduce(to introduce: String) async throws -> String
    func withdraw() async throws -> String
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

    func modifyNickname(to nickname: String) async throws -> String {
        let endPoint = userEndPointFactory.makeUserNameModifyEndPoint(userName: nickname)
        do {
            let responseData = try await provider.request(with: endPoint)
            guard let data = responseData.data else {
                os_log(.error, log: .default, "Failed to modify nickname with error: %@", responseData.message)
                return ""
            }
            return data.userName
        } catch {
            os_log(.error, log: .default, "Failed to modify nickname with error: %@", error.localizedDescription)
            return ""
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

    func modifyIntroduce(to introduce: String) async throws -> String {
        let endPoint = userEndPointFactory.makeIntroduceModifyEndPoint(introduce: introduce)
        do {
            let responseData = try await provider.request(with: endPoint)
            guard let data = responseData.data else {
                os_log(.error, log: .default, "Failed to modify introduce with error: %@", responseData.message)
                return ""
            }
            return data.introduce
        } catch {
            os_log(.error, log: .default, "Failed to modify introduce with error: %@", error.localizedDescription)
            return ""
        }
    }

    func withdraw() async throws -> String {
        let endPoint = userEndPointFactory.makeUserWithDrawEndPoint()
        do {
            let responseData = try await provider.request(with: endPoint)
            guard let data = responseData.data else {
                os_log(.error, log: .default, "Failed to withdraw with error: %@", responseData.message)
                return ""
            }
            return data.userName
        } catch {
            os_log(.error, log: .default, "Failed to withdraw with error: %@", error.localizedDescription)
            return ""
        }
    }
}
