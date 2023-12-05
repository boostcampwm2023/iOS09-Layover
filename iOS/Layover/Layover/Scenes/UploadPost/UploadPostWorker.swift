//
//  UploadPostWorker.swift
//  Layover
//
//  Created by kong on 2023/12/01.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

import OSLog

protocol UploadPostWorkerProtocol {
    func uploadPost(with request: UploadPost,
                    url: URL) async -> UploadPostDTO?
}

final class UploadPostWorker: NSObject, UploadPostWorkerProtocol {

    // MARK: - Properties

    typealias Models = UploadPostModels
    private let provider: ProviderType
    private let uploadPostEndPointFactory: UploadPostEndPointFactory

    // MARK: - Methods

    init(provider: ProviderType = Provider(),
         uploadPostEndPointFactory: UploadPostEndPointFactory = DefaultUploadPostEndPointFactory()) {
        self.provider = provider
        self.uploadPostEndPointFactory = uploadPostEndPointFactory
    }

    func uploadPost(with request: UploadPost,
                    url: URL) async -> UploadPostDTO? {
        let endPoint = uploadPostEndPointFactory.makeUploadPostEndPoint(title: request.title,
                                                                        content: request.content,
                                                                        latitude: request.latitude,
                                                                        longitude: request.longitude,
                                                                        tag: request.tag)
        do {
            let response = try await provider.request(with: endPoint)

            guard let boardID = response.data?.id else { return nil }

            let fileType = request.videoURL.pathExtension
            let upload = await uploadVideo(with: UploadVideoRequestDTO(boardID: boardID,
                                                                       filetype: fileType),
                                           videoURL: url)
            return response.data
        } catch {
            os_log(.error, log: .default, "Failed to fetch posts: %@", error.localizedDescription)
            return nil
        }
    }

    private func uploadVideo(with request: UploadVideoRequestDTO,
                             videoURL: URL) async -> Bool {
        let endPoint = uploadPostEndPointFactory.makeUploadVideoEndPoint(boardID: request.boardID,
                                                                         fileType: request.filetype)
        do {
            let response = try await provider.request(with: endPoint)
            guard let presignedURLString = response.data?.presignedUrl else { return false }
            let uploadResponse = try await provider.backgroundUpload(fromFile: videoURL,
                                                                     to: presignedURLString,
                                                                     sessionTaskDelegate: self)
            return true
        } catch {
            return false
        }
    }

}

extension UploadPostWorker: URLSessionTaskDelegate {

}
