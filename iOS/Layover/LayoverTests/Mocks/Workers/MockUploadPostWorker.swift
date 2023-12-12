//
//  MockUploadPostWorker.swift
//  LayoverTests
//
//  Created by kong on 2023/12/12.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import OSLog

@testable import Layover

final class MockUploadPostWorker: UploadPostWorkerProtocol {

    private let provider: ProviderType

    init(provider: ProviderType) {
        self.provider = provider
    }

    func uploadPost(with request: Layover.UploadPost) async -> Bool {
        guard let fileLocation = Bundle(for: type(of: self)).url(forResource: "PostBoard", withExtension: "json") else { return false }

        do {
            let endPoint: EndPoint<Response<UploadPostDTO>> = EndPoint(path: "/board",
                                                                      method: .POST,
                                                                      bodyParameters: UploadPostRequestDTO(title: request.title,
                                                                                                           content: request.content,
                                                                                                           latitude: request.latitude,
                                                                                                           longitude: request.longitude,
                                                                                                           tag: request.tag))
            let response = try await provider.request(with: endPoint)
            guard let data = response.data else { return false }
            return true
        } catch {
            os_log(.error, log: .data, "Failed to fetch posts: %@", error.localizedDescription)
            return false
        }

    }

}
