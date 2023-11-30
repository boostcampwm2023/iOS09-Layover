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
    func fetchHomePost() async -> [Post]?
}

final class HomeWorker: HomeWorkerProtocol {

    // MARK: - Properties

    private let postEndPointFactory: PostEndPointFactory
    private let provider: ProviderType
    private let authManager: AuthManager

    // MARK: - Initializer

    init(postEndPointFactory: PostEndPointFactory = DefaultPostEndPointFactory(),
         provider: ProviderType = Provider(),
         authManager: AuthManager = .shared) {
        self.postEndPointFactory = postEndPointFactory
        self.provider = provider
        self.authManager = authManager
    }

    // MARK: - Methods

    func fetchHomePost() async -> [Post]? {
        do {
            let endPoint = postEndPointFactory.makeHomePostListEndPoint()
            let response = try await provider.request(with: endPoint)
            return response.data?.map { $0.toDomain() }
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return nil
        }
    }
}
