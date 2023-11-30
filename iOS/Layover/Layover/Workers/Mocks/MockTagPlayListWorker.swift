//
//  MockTagPlayListWorker.swift
//  Layover
//
//  Created by 김인환 on 11/30/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import OSLog

final class MockTagPlayListWorker: TagPlayListWorkerProtocol {

    // MARK: - Properties

    private let provider: ProviderType = Provider(session: .initMockSession())
    private let headers: [String: String] = ["Content-Type": "application/json",
                                             "Authorization": "mock token"]

    // MARK: - Methods

    func fetchPlayList(by tag: String) async -> [Post]? {
        guard let fileLocation = Bundle.main.url(forResource: "PostList", withExtension: "json") else {
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
                                                         queryParameters: ["tag": tag],
                                                         headers: headers)

            let response = try await provider.request(with: endPoint)
            return response.data?.map { $0.toDomain() }
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return nil
        }
    }

    func loadImageData(from url: URL) async -> Data? {
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
}
