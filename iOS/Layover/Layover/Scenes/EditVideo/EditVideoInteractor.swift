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
    func fetchVideo()
}

protocol EditVideoDataStore {

}

final class EditVideoInteractor: EditVideoBusinessLogic, EditVideoDataStore {

    // MARK: - Properties

    typealias Models = EditVideoModels

    lazy var worker = EditVideoWorker()
    var presenter: EditVideoPresentationLogic?

    func fetchVideo() {
        let videoURL =  URL(string: "https://assets.afcdn.com/video49/20210722/v_645516.m3u8")!
        Task {
            let duration = try await AVAsset(url: videoURL).load(.duration)
            let seconds = CMTimeGetSeconds(duration)
            let response = Models.FetchVideo.Response(videoURL: videoURL,
                                                      duration: seconds,
                                                      isWithinRange: 3.0...60.0 ~= seconds)
            await MainActor.run {
                presenter?.presentVideo(with: response)
            }
        }
    }

}
