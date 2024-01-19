//
//  LOImageFetcher.swift
//
//
//  Created by kong on 2024/01/17.
//

import UIKit

open class LOImageFetcher {

    static let shared = LOImageFetcher()
    private let storage = LOCacheStorage()
    private let session: URLSession

    private init(session: URLSession = .shared) {
        self.session = session
    }

    @available(iOS 13.0.0, *)
    func fetchImage(from url: URL) async -> Data? {
        let key = url.lastPathComponent
        guard let storageData = storage.retrieve(forKey: key) else {
            if let (fetchedData, _) = try? await session.data(from: url) {
                return fetchedData
            } else {
                return nil
            }
        }
        return storageData
    }

}
