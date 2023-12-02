//
//  MockHomeWorker.swift
//  Layover
//
//  Created by 김인환 on 12/2/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import OSLog

final class MockHomeWorker: HomeWorkerProtocol {

    // MARK: - Properties

    private let provider: ProviderType = Provider(session: .initMockSession(),
                                                  authManager: StubAuthManager())

    // MARK: - Methods

    func fetchPosts() async -> [Post]? {
        guard let fileLocation = Bundle.main.url(forResource: "PostList",
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

    func fetchImageData(of url: URL) async -> Data? {
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
