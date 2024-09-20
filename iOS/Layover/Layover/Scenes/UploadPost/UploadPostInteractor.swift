//
//  UploadPostInteractor.swift
//  Layover
//
//  Created by kong on 2023/12/01.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import AVFoundation
import CoreLocation
import UniformTypeIdentifiers
import UIKit

import OSLog

protocol UploadPostBusinessLogic {
    func fetchTags()
    func editTags(with request: UploadPostModels.EditTags.Request)
    func fetchThumbnailImage() async
    func fetchCurrentAddress() async -> UploadPostModels.AddressInfo?
    func canUploadPost(request: UploadPostModels.CanUploadPost.Request)
    func uploadPost(request: UploadPostModels.UploadPost.Request)
    func fetchVideoAddress() async -> UploadPostModels.AddressInfo?
    func fetchAddresses() async
    func showActionSheet()
    func selectAddress(with request: UploadPostModels.SelectAddress.Request)
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
    private let locationManager: CurrentLocationManager

    // MARK: - Data Store

    var videoURL: URL?
    var isMuted: Bool?
    var tags: [String]? = []
    var videoAddress: Models.AddressInfo?
    var currentAddress: Models.AddressInfo?
    var addressType: Models.AddressType?

    // MARK: - Object LifeCycle

    init(fileManager: FileManager = FileManager.default,
         locationManager: CurrentLocationManager = CurrentLocationManager()) {
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

    func fetchThumbnailImage() async {
        guard let videoURL else { return }
        let asset = AVAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        do {
            let image = try await generator.image(at: .zero).image
            await MainActor.run {
                presenter?.presentThumbnailImage(with: Models.FetchThumbnail.Response(thumbnailImage: image))
            }
        } catch let error {
            os_log(.error, log: .data, "Failed to fetch Thumbnail Image with error: %@", error.localizedDescription)
        }
    }

    func fetchCurrentAddress() async -> UploadPostModels.AddressInfo? {
        guard let location = locationManager.getCurrentLocation() else { return nil }
        let localeIdentifier = Locale.preferredLanguages.first != nil ? Locale.preferredLanguages[0] : Locale.current.identifier
        let locale = Locale(identifier: localeIdentifier)
        do {
            let address = try await CLGeocoder().reverseGeocodeLocation(location, preferredLocale: locale).last
            let administrativeArea = address?.administrativeArea
            let locality = address?.locality
            let subLocality = address?.subLocality
            return Models.AddressInfo(
                administrativeArea: administrativeArea,
                locality: locality,
                subLocality: subLocality,
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
        } catch {
            os_log(.error, log: .data, "Failed to fetch Current Address with error: %@", error.localizedDescription)
            return nil
        }
    }

    func fetchVideoAddress() async -> UploadPostModels.AddressInfo? {
        guard let videoURL,
              let videoLocation = await worker?.loadVideoLocation(videoURL: videoURL),
              let location = locationManager.getVideoLocation(latitude: videoLocation.latitude, longitude: videoLocation.longitude)
        else { return nil }
        let localeIdentifier = Locale.preferredLanguages.first != nil ? Locale.preferredLanguages[0] : Locale.current.identifier
        let locale = Locale(identifier: localeIdentifier)
        do {
            let address = try await CLGeocoder().reverseGeocodeLocation(location, preferredLocale: locale).last
            let administrativeArea = address?.administrativeArea
            let locality = address?.locality
            let subLocality = address?.subLocality
            return Models.AddressInfo(
                administrativeArea: administrativeArea,
                locality: locality,
                subLocality: subLocality,
                latitude: videoLocation.latitude,
                longitude: videoLocation.longitude
            )
        } catch {
            os_log(.error, log: .data, "Failed to fetch Video Address with error: %@", error.localizedDescription)
            return nil
        }
    }

    func canUploadPost(request: UploadPostModels.CanUploadPost.Request) {
        let response = Models.CanUploadPost.Response(isEmpty: request.title == nil)
        presenter?.presentUploadButton(with: response)
    }

    func uploadPost(request: UploadPostModels.UploadPost.Request) {
        guard let worker,
              let videoURL,
              let isMuted,
              let addressType
        else { return }

        var addressInfo: Models.AddressInfo?
        switch addressType {
        case .video:
            if let videoAddress {
                addressInfo = videoAddress
            }
        case .current:
            if let currentAddress {
                addressInfo = currentAddress
            }
        }
        guard let addressInfo else { return }
        Task {
            if isMuted {
                await exportVideoWithoutAudio(at: videoURL)
            }
            let uploadPostResponse = await worker.uploadPost(with: UploadPost(title: request.title,
                                                                              content: request.content,
                                                                              latitude: addressInfo.latitude,
                                                                              longitude: addressInfo.longitude,
                                                                              tag: request.tags,
                                                                              videoURL: videoURL))
            guard let boardID = uploadPostResponse?.id else { return }
            let fileType = videoURL.pathExtension
            _ = await worker.uploadVideo(with: UploadVideoRequestDTO(boardID: boardID, filetype: fileType),
                                         videoURL: videoURL)
        }
    }

    func fetchAddresses() async {
        async let currentAddressInfo = fetchCurrentAddress()
        async let videoAddressInfo = fetchVideoAddress()

        videoAddress = await videoAddressInfo
        currentAddress = await currentAddressInfo
        addressType = videoAddress != nil ? .video : .current

        let response: Models.FetchCurrentAddress.Response = Models.FetchCurrentAddress.Response(addressInfo: [videoAddress, currentAddress].compactMap { $0 })
        await MainActor.run {
            presenter?.presentCurrentAddress(with: response)
        }
    }

    func selectAddress(with request: UploadPostModels.SelectAddress.Request) {
        var response: Models.FetchCurrentAddress.Response
        addressType = request.addressType
        switch request.addressType {
        case .video:
            guard let videoAddress else { return }
            response = Models.FetchCurrentAddress.Response(addressInfo: [videoAddress])
        case .current:
            guard let currentAddress else { return }
            response = Models.FetchCurrentAddress.Response(addressInfo: [currentAddress])
        }
        presenter?.presentCurrentAddress(with: response)
    }

    func showActionSheet() {
        let response: Models.ShowActionSheet.Response = Models.ShowActionSheet.Response(videoAddress: videoAddress, currentAddress: currentAddress)
        presenter?.presentShowActionSheet(with: response)
    }

    private func exportVideoWithoutAudio(at url: URL) async {
        let composition = AVMutableComposition()
        let sourceAsset = AVURLAsset(url: url)
        guard let compositionVideoTrack = composition.addMutableTrack(withMediaType: AVMediaType.video,
                                                                      preferredTrackID: kCMPersistentTrackID_Invalid) else { return }
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
            guard let videoURL else { return }
            if let outputFileType = AVFileType.from(videoURL) {
                let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough)
                exporter?.outputURL = videoURL
                exporter?.outputFileType = .from(videoURL)
                await exporter?.export()
            } else {
                presenter?.presentUnsupportedFormatAlert()
            }
        } catch {
            os_log(.error, log: .data, "Failed to extract Video Without Audio with error: %@", error.localizedDescription)
        }
    }
}
