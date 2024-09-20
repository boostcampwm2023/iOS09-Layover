//
//  MockUserWorker.swift
//  Layover
//
//  Created by kong on 2023/11/24.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import OSLog

final class MockUserWorker: UserWorkerProtocol {
    

    // MARK: - Properties

    private let provider: ProviderType = Provider(session: .initMockSession(), 
                                                  authManager: StubAuthManager())

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
        guard let fileLocation = Bundle.main.url(forResource: "PatchUserName",
                                                 withExtension: "json") else { return nil }

        do {
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
                                                                     bodyParameters: NicknameDTO(username: nickname))
            let response = try await provider.request(with: endPoint)
            guard let data = response.data else { return nil }
            return data.username
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return nil
        }
    }

    func checkNotDuplication(for userName: String) async -> Bool? {
        guard let fileLocation = Bundle.main.url(forResource: "CheckUserName",
                                                 withExtension: "json") else { return false }
        do {
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
                                                                bodyParameters: NicknameDTO(username: userName))
            let response = try await provider.request(with: endPoint, authenticationIfNeeded: false)
            return response.data?.isValid
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return false
        }
    }

    func modifyIntroduce(to introduce: String) async -> String? {
        guard let fileLocation = Bundle.main.url(forResource: "PatchIntroduce",
                                                 withExtension: "json") else { return nil }

        do {
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
                                                            bodyParameters: IntroduceDTO(introduce: introduce))
            let response = try await provider.request(with: endPoint)
            guard let data = response.data else { return nil }
            return data.introduce
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return nil
        }
    }

    func withdraw() async -> String? {
        guard let fileLocation = Bundle.main.url(forResource: "DeleteUser",
                                                 withExtension: "json") else { return nil }
        do {
            let mockData = try Data(contentsOf: fileLocation)
            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(url: request.url!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
                return (response, mockData, nil)
            }
            let endPoint = EndPoint<Response<NicknameDTO>>(path: "/member",
                                                           method: .DELETE)
            let response = try await provider.request(with: endPoint)
            guard let data = response.data else { throw NetworkError.emptyData }
            return data.username
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return nil
        }
    }

    func logout() {
        return
    }
    
    func fetchProfile(by id: Int?) async -> Member? {
        guard let fileLocation = Bundle.main.url(forResource: "GetMember", withExtension: "json") else { return nil }
        do {
            let mockData = try Data(contentsOf: fileLocation)
            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(url: request.url!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
                return (response, mockData, nil)
            }
            let endPoint = EndPoint<Response<MemberDTO>>(path: "/member",
                                                       method: .GET)
            let response = try await provider.request(with: endPoint)
            return response.data?.toDomain()
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return nil
        }
    }

    func fetchPosts(at cursor: Int?, of id: Int?) async -> PostsPage? {
//        let resourceFileName = switch page { case 1: "PostList" case 2: "PostListMore" default: "PostListEnd" }
//        let resourceFileName = cursor != nil ? "PostsPage" : "PostList"

        guard let fileLocation = Bundle(for: type(of: self)).url(forResource: "PostsPage", withExtension: "json") else { return nil }
        do {
            let mockData = try Data(contentsOf: fileLocation)
            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(url: request.url!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
                return (response, mockData, nil)
            }
            let endPoint = EndPoint<Response<PostsPageDTO>>(path: "/member/posts",
                                                          method: .GET,
                                                          queryParameters: PostRequestDTO(cursor: cursor,
                                                                                          memberId: "\(id)"))
            let response = try await provider.request(with: endPoint)
            return response.data?.toDomain()
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return nil
        }
    }
//
//    func fetchPosts(at cursor: Int?, of id: Int?) async -> PostsPage? {
//        let resourceFileName = switch cursor { case 1: "PostList" case 2: "PostListMore" default: "PostListEnd" }
//        guard let fileLocation = Bundle.main.url(forResource: resourceFileName, withExtension: "json") else { return nil }
//        do {
//            let mockData = try Data(contentsOf: fileLocation)
//            MockURLProtocol.requestHandler = { request in
//                let response = HTTPURLResponse(url: request.url!,
//                                               statusCode: 200,
//                                               httpVersion: nil,
//                                               headerFields: nil)
//                return (response, mockData, nil)
//            }
//            let endPoint = EndPoint<Response<PostsPageDTO>>(path: "/member/posts",
//                                                          method: .GET,
//                                                          queryParameters: ["cursor": cursor])
//            let response = try await provider.request(with: endPoint)
//            return response.data?.toDomain()
//        } catch {
//            os_log(.error, log: .data, "%@", error.localizedDescription)
//            return nil
//        }
//    }

    func fetchImageData(with url: URL) async -> Data? {
        do {
            guard let imageURL = Bundle.main.url(forResource: "sample", withExtension: "jpeg") else {
                return nil
            }
            let mockData = try? Data(contentsOf: imageURL)
            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(url: request.url!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
                return (response, mockData, nil)
            }

            let data = try await provider.request(url: url)
            return data
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return nil
        }
    }

    func setProfileImageDefault() async -> Bool {
        true
    }

    func modifyProfileImage(data: Data, contentType: String, to url: String) async -> Bool {
        true
    }

    func fetchImagePresignedURL(with fileType: String) async -> String? {
        return nil
    }
}
