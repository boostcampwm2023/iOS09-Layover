//
//  UploadPostInteractor.swift
//  Layover
//
//  Created by kong on 2023/12/01.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import AVFoundation
import CoreLocation
import UIKit

import OSLog

protocol UploadPostBusinessLogic {
    func fetchTags()
    func editTags(with request: UploadPostModels.EditTags.Request)

    @discardableResult
    func fetchThumbnailImage() -> Task<Bool, Never>

    func fetchCurrentAddress()
    func canUploadPost(request: UploadPostModels.CanUploadPost.Request)

    @discardableResult
    func uploadPost(request: UploadPostModels.UploadPost.Request) -> Task<Bool, Never>
}

protocol UploadPostDataStore {
    var videoURL: URL? { get set }
    var isMuted: Bool? { get set }
    var tags: [String]? { get set }
}

final class UploadPostInteractor: NSObject, UploadPostBusinessLogic, UploadPostDataStore {

    // MARK: - Properties

    typealias Models = UploadPostModels

    var worker: UploadPostWorkerProtocol?
    var presenter: UploadPostPresentationLogic?

    private let fileManager: FileManager
    private var locationManager: CurrentLocationManager

    // MARK: - Data Store

    var videoURL: URL?
    var isMuted: Bool?
    var tags: [String]? = []

    // MARK: - Object LifeCycle

    init(fileManager: FileManager = FileManager.default,
         locationManager: CurrentLocationManager) {
        self.fileManager = fileManager
        self.locationManager = locationManager
    }

    // MARK: - Methods

    func fetchTags() {
        guard let tags else { return }
        presenter?.presentTags(with: Models.FetchTags.Response(tags: tags))
    }

    func editTags(with request: UploadPostModels.EditTags.Request) {
        tags = request.tags
    }

    @discardableResult
    func fetchThumbnailImage() -> Task<Bool, Never> {
        Task {
        guard let videoURL else { return false }
        let asset = AVAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
            do {
                let image = try await generator.image(at: .zero).image
                await MainActor.run {
                    presenter?.presentThumbnailImage(with: Models.FetchThumbnail.Response(thumbnailImage: image))
                }
                return true
            } catch let error {
                os_log(.error, log: .default, "Failed to fetch Thumbnail Image with error: %@", error.localizedDescription)
                return false
            }
        }
    }

    func fetchCurrentAddress() {
        guard let location = locationManager.getCurrentLocation() else { return }
        let localeIdentifier = Locale.preferredLanguages.first != nil ? Locale.preferredLanguages[0] : Locale.current.identifier
        let locale = Locale(identifier: localeIdentifier)

        Task {
            do {
                let address = try await CLGeocoder().reverseGeocodeLocation(location, preferredLocale: locale).last
                let administrativeArea = address?.administrativeArea
                let locality = address?.locality
                let subLocality = address?.subLocality
                let response = Models.FetchCurrentAddress.Response(administrativeArea: administrativeArea,
                                                                   locality: locality,
                                                                   subLocality: subLocality)
                await MainActor.run {
                    presenter?.presentCurrentAddress(with: response)
                }
            } catch {
                os_log(.error, log: .default, "Failed to fetch Current Address with error: %@", error.localizedDescription)
            }
        }
    }

    func canUploadPost(request: UploadPostModels.CanUploadPost.Request) {
        let response = Models.CanUploadPost.Response(isEmpty: request.title == nil)
        presenter?.presentUploadButton(with: response)
    }

    @discardableResult
    func uploadPost(request: UploadPostModels.UploadPost.Request) -> Task<Bool, Never> {
        Task {
            guard let worker,
                  let videoURL,
                  let isMuted,
                  let coordinate = locationManager.getCurrentLocation()?.coordinate else { return false }
            if isMuted {
                exportVideoWithoutAudio(at: videoURL)
            }
            let response = await worker.uploadPost(with: UploadPost(title: request.title,
                                                                     content: request.content,
                                                                     latitude: coordinate.latitude,
                                                                     longitude: coordinate.longitude,
                                                                     tag: request.tags,
                                                                     videoURL: videoURL))
            return response
        }
    }

    private func exportVideoWithoutAudio(at url: URL) {
        let composition = AVMutableComposition()
        let sourceAsset = AVURLAsset(url: url)
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

                if fileManager.fileExists(atPath: url.path()) {
                    try fileManager.removeItem(at: url)
                }

                let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
                exporter?.outputURL = videoURL
                exporter?.outputFileType = AVFileType.mov
                await exporter?.export()
            } catch {
                os_log(.error, log: .data, "Failed to extract Video Without Audio with error: %@", error.localizedDescription)
            }
        }
    }

}
