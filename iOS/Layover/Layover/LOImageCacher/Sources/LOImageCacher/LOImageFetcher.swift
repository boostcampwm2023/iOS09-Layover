//
//  LOImageFetcher.swift
//
//
//  Created by kong on 2024/01/17.
//

import UIKit

final class LOImageFetcher {

    typealias ImageCacheStorage = Storage<String, Data>

    // MARK: - Properties

    static let shared = LOImageFetcher()
    private let storage: any ImageCacheStorage
    private let session: URLSession

    // MARK: - Initializer

    private init(storage: any ImageCacheStorage = LOCacheStorage(),
                 session: URLSession = .shared) {
        self.storage = storage
        self.session = session
    }

    // MARK: - Methods

    @available(iOS 13.0.0, *)
    func fetchImage(from url: URL) async -> Data? {
        let key = url.lastPathComponent
        guard let storageData = storage.retrieve(forKey: key) else {
            if let (fetchedData, _) = try? await session.data(from: url) {
                storage.store(fetchedData, forKey: key)
                storage.storeToDisk(fetchedData, forKey: key)
                return fetchedData
            } else {
                return nil
            }
        }
        return storageData
    }

}
