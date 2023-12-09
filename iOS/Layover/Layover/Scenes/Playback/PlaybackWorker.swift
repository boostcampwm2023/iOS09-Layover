//
//  PlaybackWorker.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import CoreLocation

import OSLog

protocol PlaybackWorkerProtocol {
    func deletePlaybackVideo(boardID: Int) async -> Bool
    func makeInfiniteScroll(posts: [Post]) -> [Post]
    func transLocation(latitude: Double, longitude: Double) async -> String?
}

final class PlaybackWorker: PlaybackWorkerProtocol {

    // MARK: - Properties

    typealias Models = PlaybackModels

    private let provider: ProviderType
    private let defaultPostManagerEndPointFactory: PostManagerEndPointFactory

    // MARK: - Methods

    init(provider: ProviderType = Provider(), defaultPostManagerEndPointFactory: PostManagerEndPointFactory = DefaultPostManagerEndPointFactory()) {
        self.provider = provider
        self.defaultPostManagerEndPointFactory = defaultPostManagerEndPointFactory
    }

    func makeInfiniteScroll(posts: [Post]) -> [Post] {
        guard let tempLastVideo: Post = posts.last,
              let tempFirstVideo: Post = posts.first
        else { return posts }
        var tempVideos: [Post] = posts
        tempVideos.insert(tempLastVideo, at: 0)
        tempVideos.append(tempFirstVideo)
        return tempVideos
    }

    func deletePlaybackVideo(boardID: Int) async -> Bool {
        let endPoint = defaultPostManagerEndPointFactory.deletePlaybackVideoEndpoint(boardID: boardID)
        do {
            _ = try await provider.request(with: endPoint)
            return true
        } catch {
            os_log(.error, log: .data, "Failed to delete with error: %@", error.localizedDescription)
            return false
        }
    }

    func transLocation(latitude: Double, longitude: Double) async -> String? {
        let findLocation: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-kr")

        do {
            let place = try await geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local)
            return place.last?.administrativeArea
        } catch {
            os_log(.error, "convert location error: %@", error.localizedDescription)
            return nil
        }
    }
}
