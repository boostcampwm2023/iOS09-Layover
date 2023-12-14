//
//  MockTagPlayListWorker.swift
//  LayoverTests
//
//  Created by 김인환 on 11/30/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

@testable import Layover
import Foundation
import OSLog

final class MockTagPlayListWorker: TagPlayListWorkerProtocol {

    // MARK: - Properties

    private let provider: ProviderType = Provider(session: .initMockSession(),
                                                  authManager: StubAuthManager())

    // MARK: - Methods

    func fetchPlayList(of tag: String, at page: Int) async -> [Post]? {
        let resourceFileName = switch page { case 1: "PostList" case 2: "PostListMore" default: "PostListEnd" }
        guard let fileLocation = Bundle(for: type(of: self)).url(forResource: resourceFileName, withExtension: "json") else {
            return nil
        }

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
                                                         queryParameters: ["tag": tag])

            let response = try await provider.request(with: endPoint)
            return response.data?.map { $0.toDomain() }
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return nil
        }
    }

    func loadImageData(from url: URL) async -> Data? {
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
}
