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
    func uploadPost(with request: UploadPost) async -> UploadPostDTO?
    func uploadVideo(with request: UploadVideoRequestDTO, videoURL: URL) async -> Bool
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

    func uploadPost(with request: UploadPost) async -> UploadPostDTO? {
        let endPoint = uploadPostEndPointFactory.makeUploadPostEndPoint(title: request.title,
                                                                        content: request.content,
                                                                        latitude: request.latitude,
                                                                        longitude: request.longitude,
                                                                        tag: request.tag)
        do {
            let response = try await provider.request(with: endPoint)
            return response.data
        } catch {
            os_log(.error, log: .data, "Failed to fetch posts: %@", error.localizedDescription)
            return nil
        }
    }

    func uploadVideo(with request: UploadVideoRequestDTO, videoURL: URL) async -> Bool {
        let endPoint = uploadPostEndPointFactory.makeUploadVideoEndPoint(boardID: request.boardID,
                                                                         fileType: request.filetype)
        do {
            let response = try await provider.request(with: endPoint)
            guard let preSignedURLString = response.data?.preSignedURL else { return false }
            _ = try await provider.upload(fromFile: videoURL,
                                          to: preSignedURLString,
                                          sessionTaskDelegate: self)
            NotificationCenter.default.post(name: .uploadTaskDidComplete, object: nil)
            return true
        } catch {
            os_log(.error, log: .data, "Failed to upload Video: %@", error.localizedDescription)
            NotificationCenter.default.post(name: .uploadTaskDidFail, object: nil)
            return false
        }
    }

}

extension UploadPostWorker: URLSessionTaskDelegate {

    func urlSession(_ session: URLSession, didCreateTask task: URLSessionTask) {
        NotificationCenter.default.post(name: .uploadTaskStart, object: nil)
    }

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        let uploadProgress: Float = Float(Double(totalBytesSent) / Double(totalBytesExpectedToSend))
        NotificationCenter.default.post(name: .progressChanged, object: nil, userInfo: ["progress": uploadProgress])
    }

}
