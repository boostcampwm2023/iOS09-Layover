//
//  HomeWorker.swift
//  Layover
//
//  Created by 김인환 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit
import OSLog

protocol HomeWorkerProtocol {
    func fetchPosts() async -> [Post]?
}

final class HomeWorker: HomeWorkerProtocol {

    // MARK: - Properties

    typealias Models = HomeModels

    private let provider: ProviderType
    private let postEndPointFactory: PostEndPointFactory

    init(provider: ProviderType = Provider(),
         postEndPointFactory: PostEndPointFactory = DefaultPostEndPointFactory()) {
        self.provider = provider
        self.postEndPointFactory = postEndPointFactory
    }

    // MARK: - Methods

    func fetchPosts() async -> [Post]? {
        let endPoint = postEndPointFactory.makeHomePostListEndPoint()

        do {
            let response = try await provider.request(with: endPoint)
            return response.data?.map { $0.toDomain() }
        } catch {
            os_log(.error, log: .default, "Failed to fetch posts: %@", error.localizedDescription)
            return nil
        }
    }
}
