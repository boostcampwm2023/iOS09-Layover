//
//  Prefetcher.swift
//  Layover
//
//  Created by 황지웅 on 1/18/24.
//  Copyright © 2024 CodeBomber. All rights reserved.
//

import Foundation
import CoreLocation
import OSLog

protocol PrefetchProtocol {
    func prefetchImage(for key: URL) async -> Data?
    func prefetchLocation(latitude: Double, longitude: Double) async -> String?
    func cancelPrefetchImage(for key: URL) async
    func cancelPrefetchLocation(latitude: Double, longitude: Double) async
}

actor Prefetcher: PrefetchProtocol {
    private let imageCache: NSCache<NSURL, NSData> = {
        let cache = NSCache<NSURL, NSData>()
        // 10MB
        cache.totalCostLimit = 10 * 1024 * 1024
        return cache
    }()

    private let locationCache: NSCache<NSString, NSString> = {
        let cache = NSCache<NSString, NSString>()
        // 5MB
        cache.totalCostLimit = 5 * 1024 * 1024
        return cache
    }()

    private var fetchingImageTasks: [URL: Task<Data, Error>] = [:]
    private var fetchingLocationTasks: [String: Task<String?, Error>] = [:]

    private let provider: ProviderType = Provider()

    func prefetchImage(for key: URL) async -> Data? {
        if let cachedData = imageCache.object(forKey: key as NSURL) as? Data {
            return cachedData
        }

        if let prefetchingData = fetchingImageTasks[key] {
            do {
                return try await prefetchingData.value
            } catch {
                os_log(.error, log: .data, "%@", error.localizedDescription)
                return nil
            }
        }
        
        let fetchTask: Task<Data, Error> = download(key)
        fetchingImageTasks[key] = fetchTask

        do {
            let fetchedData: Data = try await fetchTask.value
            imageCache.setObject(fetchedData as NSData, forKey: key as NSURL)
            fetchingImageTasks[key] = nil
            return fetchedData
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return nil
        }
    }

    func prefetchLocation(latitude: Double, longitude: Double) async -> String? {
        let cacheKey = "\(latitude)-\(longitude)"

        if let cachedData = locationCache.object(forKey: cacheKey as NSString) as? String {
            return cachedData
        }

        if let prefetchingData = fetchingLocationTasks[cacheKey] {
            do {
                return try await prefetchingData.value
            } catch {
                os_log(.error, log: .data, "%@", error.localizedDescription)
                return nil
            }
        }

        let fetchTask: Task<String?, Error> = loadLocationInfo(latitude: latitude, longitude: longitude)
        fetchingLocationTasks[cacheKey] = fetchTask

        do {
            guard let fetchedData: String = try await fetchTask.value else { return nil }
            locationCache.setObject(fetchedData as NSString, forKey: cacheKey as NSString)
            return fetchedData
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return nil
        }
    }

    func cancelPrefetchImage(for key: URL) async {
        fetchingImageTasks[key]?.cancel()
        fetchingImageTasks[key] = nil
    }

    func cancelPrefetchLocation(latitude: Double, longitude: Double) async {
        let key = "\(latitude)-\(longitude)"
        fetchingLocationTasks[key]?.cancel()
        fetchingLocationTasks[key] = nil
    }

    private func download(_ url: URL) -> Task<Data, Error> {
        return Task {
            try await provider.request(url: url)
        }
    }

    private func loadLocationInfo(latitude: Double, longitude: Double) -> Task<String?, Error> {
         return Task {
            let findLocation: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
            let geoCoder: CLGeocoder = CLGeocoder()
            let localeIdentifier = Locale.preferredLanguages.first != nil ? Locale.preferredLanguages[0] : Locale.current.identifier
            let locale = Locale(identifier: localeIdentifier)
            let place = try await geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: locale)
            return place.last?.administrativeArea
        }
    }
}
