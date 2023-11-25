//
//  MockUserWorker.swift
//  Layover
//
//  Created by kong on 2023/11/24.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import UIKit

final class MockUserWorker: UserWorkerProtocol {

    // MARK: - Properties

    private let provider: ProviderType

    private let headers: [String: String] = ["Content-Type": "application/json",
                                             "Authorization": "mock token"]

    init(provider: ProviderType) {
        self.provider = provider
    }

    // MARK: - Methods

    // MARK: Screen Specific Validation

    func modifyNickname(to nickname: String) async throws -> Result<String, NetworkError> {
        let endPoint: EndPoint = EndPoint<Response<NicknameDTO>>(path: "/member/username",
                                                            method: .PATCH,
                                                            bodyParameters: NicknameDTO(userName: nickname),
                                                            headers: headers)
        let response = try await provider.request(with: endPoint)
        guard let data = response.data else { return .failure(.emptyData) }
        switch response.statusCode {
        case 200:
            return .success(data.userName)
        default:
            return .failure(NetworkError.server(.badRequest))
        }
    }

    func checkDuplication(for nickname: String) async throws -> Result<Bool, NetworkError> {
        let endPoint = EndPoint<Response<CheckUserNameDTO>>(path: "/member/check-username", 
                                                            method: .POST,
                                                            bodyParameters: NicknameDTO(userName: nickname),
                                                            headers: headers)
        let response = try await provider.request(with: endPoint)

        guard let data = response.data else { return .failure(.emptyData) }
        switch response.statusCode {
        case 200:
            return .success(data.exist)
        default:
            return .failure(NetworkError.server(.badRequest))
        }
    }

    func modifyIntroduce(to introduce: String) async throws -> Result<String, NetworkError> {
        let endPoint = EndPoint<Response<IntroduceDTO>>(path: "/member/introduce",
                                                  method: .PATCH,
                                                  bodyParameters: IntroduceDTO(introduce: introduce),
                                                  headers: headers)
        let response = try await provider.request(with: endPoint)
        guard let data = response.data else { return .failure(.emptyData) }
        switch response.statusCode {
        case 200:
            return .success(data.introduce)
        default:
            return .failure(NetworkError.server(.badRequest))
        }
    }

    func withdraw() async throws -> Result<String, NetworkError> {
        let endPoint = EndPoint<Response<NicknameDTO>>(path: "/member",
                                                  method: .DELETE,
                                                  headers: ["Content-Type": "application/json"])
        let response = try await provider.request(with: endPoint)
        guard let data = response.data else { return .failure(.emptyData) }
        switch response.statusCode {
        case 200:
            return .success(data.userName)
        default:
            return .failure(NetworkError.server(.badRequest))
        }
    }

}

protocol UserWorkerProtocol {
    func modifyNickname(to nickname: String) async throws -> Result<String, NetworkError>
    func checkDuplication(for nickname: String) async throws -> Result<Bool, NetworkError>
    // TODO: multipart request 구현
    // func modifyProfileImage() async throws -> Result<URL, NetworkError>
    func modifyIntroduce(to introduce: String) async throws -> Result<String, NetworkError>
    func withdraw() async throws -> Result<String, NetworkError>
}
