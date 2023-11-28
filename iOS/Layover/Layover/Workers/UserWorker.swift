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

    // MARK: Properties

    private let userEndPointFactory: UserEndPointFactory
    private let provider: ProviderType

    // MARK: Intializer

    init(userEndPointFactory: UserEndPointFactory = DefaultUserEndPointFactory(),
         provider: ProviderType = Provider()) {
        self.userEndPointFactory = userEndPointFactory
        self.provider = provider
    }

    // MARK: Methods

    func modifyNickname(to nickname: String) async throws -> String {
        return ""
    }

    func checkDuplication(for userName: String) async throws -> Bool {
        let endPoint = userEndPointFactory.makeCheckUserNameEndPoint(of: userName)
        do {
            let responseData = try await provider.request(with: endPoint, authenticationIfNeeded: false)
            guard let data = try await provider.request(with: endPoint, authenticationIfNeeded: false).data else {
                os_log(.error, log: .default, "Failed to check duplicate username with error: %@", responseData.message)
                return true
            }
            return data.exist
        } catch {
            os_log(.error, log: .default, "Failed to check duplicate username with error: %@", error.localizedDescription)
            return true
        }
    }

    func modifyIntroduce(to introduce: String) async throws -> String {
        return ""
    }

    func withdraw() async throws -> String {
        return ""
    }
}
