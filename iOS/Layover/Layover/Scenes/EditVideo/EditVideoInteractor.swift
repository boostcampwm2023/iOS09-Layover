//
//  EditVideoInteractor.swift
//  Layover
//
//  Created by kong on 2023/11/29.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import AVFoundation
import UIKit

protocol EditVideoBusinessLogic {
    func fetchVideo(request: EditVideoModels.FetchVideo.Request)
    func deleteVideo()
}

protocol EditVideoDataStore {
    var videoURL: URL? { get set }
}

final class EditVideoInteractor: EditVideoBusinessLogic, EditVideoDataStore {

    // MARK: - Properties

    typealias Models = EditVideoModels

    var videoFileWorker: VideoFileWorker?
    var presenter: EditVideoPresentationLogic?

    var videoURL: URL?

    func fetchVideo(request: EditVideoModels.FetchVideo.Request) {
        let isEdited = request.editedVideoURL != nil
        guard let videoURL = isEdited ? request.editedVideoURL : videoURL else { return }

        Task {
            let duration = try await AVAsset(url: videoURL).load(.duration)
            let seconds = CMTimeGetSeconds(duration)
            let response = Models.FetchVideo.Response(isEdited: isEdited,
                                                      videoURL: videoURL,
                                                      duration: seconds,
                                                      isWithinRange: request.videoRange ~= seconds)
            await MainActor.run {
                presenter?.presentVideo(with: response)
            }
        }
    }

    func deleteVideo() {
        guard let videoURL else { return }
        videoFileWorker?.delete(at: videoURL)
    }

}
