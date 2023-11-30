//
//  MockHomeWorker.swift
//  Layover
//
//  Created by 김인환 on 12/1/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import OSLog

final class MockHomeWorker: HomeWorkerProtocol {

    // MARK: - Properties

    private let postEndPointFactory: PostEndPointFactory
    private let provider: ProviderType
    private let authManager: AuthManager

    // MARK: - Initializer

    init(postEndPointFactory: PostEndPointFactory = DefaultPostEndPointFactory(),
         provider: ProviderType = Provider(session: .initMockSession()),
         authManager: AuthManager = .shared) {
        self.postEndPointFactory = postEndPointFactory
        self.provider = provider
        self.authManager = authManager
    }

    // MARK: - Methods

    func fetchHomePost() async -> [Post]? {
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

            let endPoint = EndPoint<Response<[PostDTO]>>(path: "/board/home", method: .GET)
            let response = try await provider.request(with: endPoint, authenticationIfNeeded: false)
            return response.data?.map { $0.toDomain() }
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return nil
        }
    }
}
