//
//  MockUserWorker.swift
//  Layover
//
//  Created by kong on 2023/11/24.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

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

final class MockUserWorker: UserWorkerProtocol {

    // MARK: - Properties

    private let provider: ProviderType = Provider(session: .initMockSession())
    private let headers: [String: String] = ["Content-Type": "application/json",
                                             "Authorization": "mock token"]

    // MARK: - Methods

    func validateNickname(_ nickname: String) -> NicknameState {
        if nickname.count < 2 || nickname.count > 8 {
            return .lessThan2GreaterThan8
        } else if nickname.wholeMatch(of: /^[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣]+/) == nil {
            return .invalidCharacter
        }
        return .valid
    }

    func updateNickname(to nickname: String) async throws -> String {
        guard let fileLocation = Bundle.main.url(forResource: "PatchUserName",
                                                 withExtension: "json") else { throw NetworkError.unknown }
        let mockData = try Data(contentsOf: fileLocation)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response, mockData, nil)
        }
        let endPoint: EndPoint = EndPoint<Response<NicknameDTO>>(path: "/member/username",
                                                            method: .PATCH,
                                                            bodyParameters: NicknameDTO(userName: nickname),
                                                            headers: headers)
        let response = try await provider.request(with: endPoint)
        guard let data = response.data else { throw NetworkError.emptyData }
        return data.userName
    }

    func checkDuplication(for nickname: String) async throws -> Bool {
        guard let fileLocation = Bundle.main.url(forResource: "CheckUserName",
                                                 withExtension: "json") else { throw NetworkError.unknown }
        let mockData = try Data(contentsOf: fileLocation)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response, mockData, nil)
        }
        let endPoint = EndPoint<Response<CheckUserNameDTO>>(path: "/member/check-username",
                                                            method: .POST,
                                                            bodyParameters: NicknameDTO(userName: nickname),
                                                            headers: headers)
        let response = try await provider.request(with: endPoint)
        guard let data = response.data else { throw NetworkError.emptyData }
        return data.exist
    }

    func updateIntroduce(to introduce: String) async throws -> String {
        guard let fileLocation = Bundle.main.url(forResource: "PatchIntroduce",
                                                 withExtension: "json") else { throw NetworkError.unknown }
        let mockData = try Data(contentsOf: fileLocation)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response, mockData, nil)
        }

        let endPoint = EndPoint<Response<IntroduceDTO>>(path: "/member/introduce",
                                                      method: .PATCH,
                                                      bodyParameters: IntroduceDTO(introduce: introduce),
                                                      headers: headers)
        let response = try await provider.request(with: endPoint)
        guard let data = response.data else { throw NetworkError.emptyData }
        return data.introduce
    }

    func withdraw() async throws -> String {
        guard let fileLocation = Bundle.main.url(forResource: "DeleteUser",
                                                 withExtension: "json") else { throw NetworkError.unknown }
        let mockData = try Data(contentsOf: fileLocation)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response, mockData, nil)
        }
        let endPoint = EndPoint<Response<NicknameDTO>>(path: "/member",
                                                  method: .DELETE,
                                                  headers: ["Authorization": "mock token"])
        let response = try await provider.request(with: endPoint)
        guard let data = response.data else { throw NetworkError.emptyData }
        return data.userName
    }

}

protocol UserWorkerProtocol {
    func validateNickname(_ nickname: String) -> NicknameState
    func updateNickname(to nickname: String) async throws -> String
    func checkDuplication(for nickname: String) async throws -> Bool
    // TODO: multipart request 구현
    // func updateProfileImage() async throws -> URL
    func updateIntroduce(to introduce: String) async throws -> String
    func withdraw() async throws -> String
}
