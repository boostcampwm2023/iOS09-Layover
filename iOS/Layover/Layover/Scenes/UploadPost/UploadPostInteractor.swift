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
    func fetchThumbnailImage()
    func fetchCurrentAddress()
    func canUploadPost(request: UploadPostModels.CanUploadPost.Request)
    func uploadPost(request: UploadPostModels.UploadPost.Request)
}

protocol UploadPostDataStore {
    var videoURL: URL? { get set }
    var isMuted: Bool? { get set }
    var tags: [String]? { get set }
}

final class UploadPostInteractor: UploadPostBusinessLogic, UploadPostDataStore {

    // MARK: - Properties

    typealias Models = UploadPostModels

    lazy var worker = UploadPostWorker()
    var presenter: UploadPostPresentationLogic?

    private let fileManager: FileManager
    private let locationManager: CLLocationManager

    // MARK: - Data Store

    var videoURL: URL?
    var isMuted: Bool?
    var tags: [String]? = []

    // MARK: - Object LifeCycle

    init(fileManager: FileManager = FileManager.default,
         locationManager: CLLocationManager = CLLocationManager()) {
        self.fileManager = fileManager
        self.locationManager = locationManager
    }

    // MARK: - Methods

    func fetchTags() {
        guard let tags else { return }
        presenter?.presentTags(with: UploadPostModels.FetchTags.Response(tags: tags))
    }

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
                os_log(.error, log: .default, "Failed to fetch Thumbnail Image with error: %@", error.localizedDescription)
            }
        }
    }

    func fetchCurrentAddress() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        guard let space = locationManager.location?.coordinate else { return }
        let location = CLLocation(latitude: space.latitude,
                                  longitude: space.longitude)
        let locale = Locale(identifier: "ko_KR")

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
        let response = UploadPostModels.CanUploadPost.Response(isEmpty: request.title == nil)
        presenter?.presentUploadButton(with: response)
    }

    func uploadPost(request: UploadPostModels.UploadPost.Request) {
        guard let videoURL, let isMuted else { return }
        if isMuted {
            exportVideoWithoutAudio(at: videoURL)
        }




    }

    // isMuted가 true인 경우, 새로운 Composition을 만들어서 영상 재추출해서 업로드
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
                os_log(.error, log: .default, "Failed to extract Video Without Audio with error: %@", error.localizedDescription)
            }
        }
    }

}
