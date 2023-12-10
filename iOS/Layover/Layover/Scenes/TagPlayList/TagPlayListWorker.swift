//
//  TagPlayListWorker.swift
//  Layover
//
//  Created by 김인환 on 11/29/23.
//  Copyright (c) 2023 CodeBomber. All rights reserved.
//

import UIKit
import OSLog

protocol TagPlayListWorkerProtocol {
    func fetchPlayList(of tag: String, at page: Int) async -> [Post]?
    func loadImageData(from url: URL) async -> Data?
}

final class TagPlayListWorker: TagPlayListWorkerProtocol {

    // MARK: - Properties

    typealias Models = TagPlayListModels

    let provider: ProviderType
    let authManager: AuthManager
    let postEndPointFactory: PostEndPointFactory

    // MARK: - Initializer

    init(provider: ProviderType = Provider(),
         postEndPointFactory: PostEndPointFactory = DefaultPostEndPointFactory(),
         authManager: AuthManager = AuthManager.shared) {
        self.provider = provider
        self.postEndPointFactory = postEndPointFactory
        self.authManager = authManager
    }

    // MARK: - Methods

    func fetchPlayList(of tag: String, at page: Int) async -> [Post]? {
        let endPoint = postEndPointFactory.makeTagSearchPostListEndPoint(of: tag, at: page)
        do {
            let responseData = try await provider.request(with: endPoint)
            return responseData.data?.map { $0.toDomain() }
        } catch {
            os_log(.error, log: .default, "Error occured while fetching post list: %s", error.localizedDescription)
            return nil
        }
    }

    func loadImageData(from url: URL) async -> Data? {
        do {
            return try await provider.request(url: url)
        } catch {
            os_log(.error, log: .default, "Error occured while fetching image data: %s", error.localizedDescription)
            return nil
        }
    }
}
