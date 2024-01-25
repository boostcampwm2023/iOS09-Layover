// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

// MARK: - Protocol

protocol Storage<Key, Value> {
    associatedtype Key
    associatedtype Value

    func store(_ data: Value, forKey key: Key)
    func storeToDisk(_ data: Value, forKey key: Key)
    func retrieve(forKey key: Key) -> Value?
}

final class LOCacheStorage: Storage {

    typealias Key = String
    typealias Value = Data
    typealias Cache = NSCache<NSString, NSData>

    // MARK: - Properties

    private let memory: Cache
    private let disk: FileManager

    // MARK: - Initializer

    init(memory: Cache = Cache(),
         disk: FileManager = .default) {
        self.memory = memory
        self.disk = disk
    }

    // MARK: - Methods

    func store(_ data: Value, forKey key: Key) {
        memory.setObject(data as NSData, forKey: key as NSString)
    }

    func storeToDisk(_ data: Value, forKey key: Key) {
        let path = cacheURL(forKey: key).path
        disk.createFile(atPath: path, contents: data)
    }

    func retrieve(forKey key: Key) -> Value? {
        if let memorydata = memory.object(forKey: key as NSString) {
            return memorydata as Value
        }

        let path = cacheURL(forKey: key).path
        if disk.fileExists(atPath: path),
           let data = disk.contents(atPath: path) {
            self.store(data, forKey: key)
            return data
        } else {
            return nil
        }
    }

    private func cacheURL(forKey key: Key) -> URL {
        let directoryURL = disk.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        if #available(iOS 16.0, *) {
            return directoryURL.appending(path: key)
        } else {
            return directoryURL.appendingPathComponent(key)
        }
    }

}
