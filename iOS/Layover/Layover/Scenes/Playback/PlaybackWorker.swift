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
    func fetchImageData(with url: URL?) async -> Data?
    func fetchHomePosts() async -> [Post]?
    func fetchProfilePosts(profileID: Int?, page: Int) async -> [Post]?
    func fetchTagPosts(selectedTag: String, page: Int) async -> [Post]?
    func isMyVideo(currentCellMemberID: Int) -> Bool
    @discardableResult
    func prefetchProfileImage(with url: URL?) async -> Data?
    @discardableResult
    func prefetchLocation(latitude: Double, longitude: Double) async -> String?
    func cancelPrefetchProfileImage(with url: URL?) async
    func cancelPrefetchLocation(latitude: Double, longitude: Double) async
}

final class PlaybackWorker: PlaybackWorkerProtocol {

    // MARK: - Properties

    typealias Models = PlaybackModels

    private let provider: ProviderType
    private let authManager: AuthManagerProtocol
    private let defaultPostManagerEndPointFactory: PostManagerEndPointFactory
    private let defaultPostEndPointFactory: PostEndPointFactory
    private let defaultUserEndPointFactory: UserEndPointFactory
    private let prefetcher: PrefetchProtocol

    // MARK: - Methods

    init(provider: ProviderType = Provider(), authManager: AuthManagerProtocol = AuthManager.shared, defaultPostManagerEndPointFactory: PostManagerEndPointFactory = DefaultPostManagerEndPointFactory(), defaultPostEndPointFactory: PostEndPointFactory = DefaultPostEndPointFactory(), defaultUserEndPointFactory: UserEndPointFactory = DefaultUserEndPointFactory(), prefetcher: PrefetchProtocol = Prefetcher()) {
        self.provider = provider
        self.defaultPostManagerEndPointFactory = defaultPostManagerEndPointFactory
        self.defaultPostEndPointFactory = defaultPostEndPointFactory
        self.defaultUserEndPointFactory = defaultUserEndPointFactory
        self.authManager = authManager
        self.prefetcher = prefetcher
    }

    func makeInfiniteScroll(posts: [Post]) -> [Post] {
        var tempVideos: [Post] = []
        for post in posts {
            if post.board.videoURL != nil, post.board.status == .complete {
                tempVideos.append(post)
            }
        }
        guard let tempLastVideo: Post = tempVideos.last,
              let tempFirstVideo: Post = tempVideos.first
        else { return tempVideos }
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
        let localeIdentifier = Locale.preferredLanguages.first != nil ? Locale.preferredLanguages[0] : Locale.current.identifier
        let locale = Locale(identifier: localeIdentifier)
        do {
            let place = try await geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: locale)
            return place.last?.administrativeArea
        } catch {
            os_log(.error, "convert location error: %@", error.localizedDescription)
            return nil
        }
    }

    func fetchImageData(with url: URL?) async -> Data? {
        guard let url else { return nil }
        do {
            return try await provider.request(url: url)
        } catch {
            os_log(.error, log: .data, "Error: %s", error.localizedDescription)
            return nil
        }
    }

    func fetchHomePosts() async -> [Post]? {
        let endPoint = defaultPostEndPointFactory.makeHomePostListEndPoint()
        do {
            let response = try await provider.request(with: endPoint)
            return response.data?.map { $0.toDomain() }
        } catch {
            os_log(.error, log: .data, "Failed to fetch posts: %@", error.localizedDescription)
            return nil
        }
    }

    func fetchProfilePosts(profileID: Int?, page: Int) async -> [Post]? {
        let endPoint = defaultUserEndPointFactory.makeUserPostsEndPoint(at: page, of: profileID)
        do {
            let response = try await provider.request(with: endPoint)
            return response.data?.map { $0.toDomain() }
        } catch {
            os_log(.error, log: .data, "Failed to fetch posts: %@", error.localizedDescription)
            return nil
        }
    }

    func fetchTagPosts(selectedTag: String, page: Int) async -> [Post]? {
        let endPoint = defaultPostEndPointFactory.makeTagSearchPostListEndPoint(of: selectedTag, at: page)
        do {
            let response = try await provider.request(with: endPoint)
            return response.data?.map { $0.toDomain() }
        } catch {
            os_log(.error, log: .data, "Failed to fetch posts: %@", error.localizedDescription)
            return nil
        }
    }

    func isMyVideo(currentCellMemberID: Int) -> Bool {
        let myMemberID = authManager.memberID
        return currentCellMemberID == myMemberID
    }

    func prefetchProfileImage(with url: URL?) async -> Data? {
        guard let url else { return nil }
        return await prefetcher.prefetchImage(for: url)
    }

    func prefetchLocation(latitude: Double, longitude: Double) async -> String? {
        await prefetcher.prefetchLocation(latitude: latitude, longitude: longitude)
    }

    func cancelPrefetchProfileImage(with url: URL?) async {
        guard let url else { return }
        await prefetcher.cancelPrefetchImage(for: url)
    }

    func cancelPrefetchLocation(latitude: Double, longitude: Double) async {
        await prefetcher.cancelPrefetchLocation(latitude: latitude, longitude: longitude)
    }
}
