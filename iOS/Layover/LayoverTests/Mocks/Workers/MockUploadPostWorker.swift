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

    init(provider: ProviderType = Provider(session: .initMockSession(),
                                           authManager: StubAuthManager())) {
        self.provider = provider
    }

    func uploadPost(with request: UploadPost) async -> UploadPostDTO? {
        guard let fileLocation = Bundle(for: type(of: self)).url(forResource: "PostBoard",
                                                                 withExtension: "json") else { return nil }
        do {
            let endPoint: EndPoint<Response<UploadPostDTO>> = EndPoint(path: "/board",
                                                                      method: .POST,
                                                                      bodyParameters: UploadPostRequestDTO(title: request.title,
                                                                                                           content: request.content,
                                                                                                           latitude: request.latitude,
                                                                                                           longitude: request.longitude,
                                                                                                           tag: request.tag))
            let mockData = try Data(contentsOf: fileLocation)
            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(url: request.url!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
                return (response, mockData, nil)
            }
            let response = try await provider.request(with: endPoint)
            guard let data = response.data else { return nil }
            return data
        } catch {
            os_log(.error, log: .data, "Failed to fetch posts: %@", error.localizedDescription)
            return nil
        }

    }

    func uploadVideo(with request: UploadVideoRequestDTO, videoURL: URL) async -> Bool {
        return true
    }

    func loadVideoLocation(videoURL: URL) async -> Layover.UploadPostModels.VideoAddress? {
        nil
    }

}
