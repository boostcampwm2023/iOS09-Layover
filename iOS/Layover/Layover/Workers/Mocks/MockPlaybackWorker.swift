//
//  MockPlaybackWorker.swift
//  Layover
//
//  Created by 황지웅 on 12/7/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import CoreLocation
import OSLog

final class MockPlaybackWorker: PlaybackWorkerProtocol {

    // MARK: - Properties

    typealias Models = PlaybackModels

    private let provider: ProviderType

    // MARK: - Methods

    init(provider: ProviderType = Provider(session: .initMockSession())) {
        self.provider = provider
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
        guard let mockFileLocation = Bundle.main.url(forResource: "DeleteVideo", withExtension: "json"),
              let mockData = try? Data(contentsOf: mockFileLocation)
        else {
            os_log(.error, log: .data, "Failed to generate mock with error: %@", "Generate File Error")
            return false
        }

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)
            return (response, mockData, nil)
        }

        do {
            let endPoint = EndPoint<EmptyData>(
                path: "/board",
                method: .DELETE,
                queryParameters: ["boardId": boardID])
            _ = try await provider.request(with: endPoint)
            return true
        } catch {
            os_log(.error, log: .data, "Failed to delete with error%@", error.localizedDescription)
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
