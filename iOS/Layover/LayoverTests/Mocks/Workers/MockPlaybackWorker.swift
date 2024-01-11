//
//  MockPlaybackWorker.swift
//  Layover
//
//  Created by 황지웅 on 12/7/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

@testable import Layover
import Foundation
import OSLog

final class MockPlaybackWorker: PlaybackWorkerProtocol {

    // MARK: - Properties

    typealias Models = PlaybackModels

    private let provider: ProviderType = Provider(session: .initMockSession(), authManager: StubAuthManager())
    private let authManager: AuthManagerProtocol = StubAuthManager()

    // MARK: - Methods

//    init(provider: ProviderType = Provider(session: .initMockSession()), authManager: AuthManagerProtocol = StubAuthManager()) {
//        self.provider = provider
//        self.authManager = authManager
//    }

    func makeInfiniteScroll(posts: [Post]) -> [Post] {
        var tempVideos: [Post] = []
        for post in posts {
            if post.board.videoURL == nil {
                continue
            }
            tempVideos.append(post)
        }
        guard let tempLastVideo: Post = tempVideos.last,
              let tempFirstVideo: Post = tempVideos.first
        else { return posts }
        tempVideos.insert(tempLastVideo, at: 0)
        tempVideos.append(tempFirstVideo)
        return tempVideos
    }

    func deletePlaybackVideo(boardID: Int) async -> Bool {
        guard let mockFileLocation = Bundle(for: type(of: self)).url(forResource: "DeleteVideo", withExtension: "json"),
              let mockData = try? Data(contentsOf: mockFileLocation)
        else {
            os_log(.error, log: .data, "Failed to generate mock with error: %@", "Generate File Error")
            return false
        }

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)
            return (response, mockData, nil)
        }

        do {
            let endPoint = EndPoint<EmptyData>(
                path: "/board",
                method: .DELETE,
                queryParameters: ["boardId": boardID])
            _ = try await provider.request(with: endPoint)
            return true
        } catch {
            os_log(.error, log: .data, "Failed to delete with error%@", error.localizedDescription)
            return false
        }
    }

    func transLocation(latitude: Double, longitude: Double) async -> String? {
        "서울특별시"
    }

    func fetchImageData(with url: URL?) async -> Data? {
        guard let url else { return nil }
        do {
            guard let imageURL = Bundle(for: type(of: self)).url(forResource: "sample", withExtension: "jpeg") else {
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

    func fetchHomePosts() async -> [Post]? {
        guard let fileLocation = Bundle(for: type(of: self)).url(forResource: "PostList", withExtension: "json") else { return nil }
        do {
            let mockData = try Data(contentsOf: fileLocation)
            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(url: request.url!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
                return (response, mockData, nil)
            }
            let endPoint: EndPoint = EndPoint<Response<[PostDTO]>>(path: "/board/home",
                                                                   method: .GET)
            let response = try await provider.request(with: endPoint)
            guard let data = response.data else { return nil }
            return data.map { $0.toDomain() }
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return nil
        }
    }

    func fetchProfilePosts(profileID: Int?, page: Int) async -> [Post]? {
        let resourceFileName = switch page { case 1: "PostList" case 2: "PostListMore" default: "PostListEnd" }
        guard let fileLocation = Bundle(for: type(of: self)).url(forResource: resourceFileName, withExtension: "json") else { return nil }
        do {
            let mockData = try Data(contentsOf: fileLocation)
            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(url: request.url!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
                return (response, mockData, nil)
            }
            let endPoint = EndPoint<Response<[PostDTO]>>(path: "/member/posts",
                                                          method: .GET,
                                                          queryParameters: ["page": page])
            let response = try await provider.request(with: endPoint)
            return response.data?.map { $0.toDomain() }
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return nil
        }
    }

    func fetchTagPosts(selectedTag: String, page: Int) async -> [Post]? {
        let resourceFileName = switch page { case 1: "PostList" case 2: "PostListMore" default: "PostListEnd" }
        guard let fileLocation = Bundle(for: type(of: self)).url(forResource: resourceFileName, withExtension: "json") else { return nil }

        do {
            let mockData = try? Data(contentsOf: fileLocation)
            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(url: request.url!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
                return (response, mockData, nil)
            }

            let endPoint = EndPoint<Response<[PostDTO]>>(path: "/board/tag",
                                                         method: .GET,
                                                         queryParameters: ["tag": selectedTag])

            let response = try await provider.request(with: endPoint)
            return response.data?.map { $0.toDomain() }
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return nil
        }
    }

    func isMyVideo(currentCellMemberID: Int) -> Bool {
        return true
    }

}
