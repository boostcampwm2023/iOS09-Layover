//
//  UploadPostInteractor.swift
//  Layover
//
//  Created by kong on 2023/12/01.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import AVFoundation
import UIKit

import OSLog

protocol UploadPostBusinessLogic {
    func fetchThumbnailImage()
    func uploadPost()
}

protocol UploadPostDataStore {
    var videoURL: URL? { get set }
    var isMuted: Bool? { get set }
}

final class UploadPostInteractor: UploadPostBusinessLogic, UploadPostDataStore {

    // MARK: - Properties

    typealias Models = UploadPostModels

    lazy var worker = UploadPostWorker()
    var presenter: UploadPostPresentationLogic?

    // MARK: - Data Store

    var videoURL: URL?
    var isMuted: Bool?

    func fetchThumbnailImage() {
        guard let videoURL else { return }
        let asset = AVAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        Task {
            do {
                let image = try await generator.image(at: .zero).image
                await MainActor.run {
                    presenter?.presentThumnailImage(with: UploadPostModels.FetchThumbnail.Response(thumnailImage: image))
                }
            } catch let error {
                os_log(.error, log: .default, "Failed to fetch ThumbnailImage with error: %@", error.localizedDescription)
            }
        }
    }

    func uploadPost() {
        guard let isMuted else { return }
        if isMuted {
            extractVideoWithoutAudio()
        }
    }

    private func extractVideoWithoutAudio() {
        guard let videoURL else { return }

        let composition = AVMutableComposition()
        let sourceAsset = AVURLAsset(url: videoURL)
        guard let compositionVideoTrack = composition.addMutableTrack(withMediaType: AVMediaType.video,
                                                                      preferredTrackID: kCMPersistentTrackID_Invalid) else { return }

        Task {
            do {
                let sourceAssetduration = try await sourceAsset.load(.duration)
                let sourceVideoTrack = try await sourceAsset.load(.tracks)[0]
                compositionVideoTrack.preferredTransform = try await sourceVideoTrack.load(.preferredTransform)

                let timeRange: CMTimeRange = CMTimeRangeMake(start: .zero, duration: sourceAssetduration)
                try compositionVideoTrack.insertTimeRange(timeRange,
                                                           of: sourceVideoTrack,
                                                           at: .zero)

                if FileManager.default.fileExists(atPath: videoURL.path()) {
                    try FileManager.default.removeItem(at: videoURL)
                }

                let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
                exporter?.outputURL = videoURL
                exporter?.outputFileType = AVFileType.mov
                await exporter?.export()
            } catch let error {
                os_log(.error, log: .default, "Failed to fetch extractVideoWithoutAudio with error: %@", error.localizedDescription)
            }
        }
    }

}
