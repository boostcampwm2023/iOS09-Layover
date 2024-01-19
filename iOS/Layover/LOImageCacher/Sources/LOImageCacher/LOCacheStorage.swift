// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

open class LOCacheStorage {
    typealias Key = String
    typealias Value = Data
    typealias Cache = NSCache<NSString, NSData>

    private let memory: Cache
    private let disk: FileManager

    init(memory: Cache = Cache(),
         disk: FileManager = .default) {
        self.memory = memory
        self.disk = disk
    }

    func store(_ data: Data,
               forKey key: Key) {
        memory.setObject(data as NSData,
                         forKey: key as NSString)
    }

    func storeToDisk(_ data: Data,
                     forKey key: Key) {
        let path = cacheURL(forKey: key).absoluteString
        disk.createFile(atPath: path,
                        contents: data)
    }


    func retrieve(forKey key: Key) -> Data? {
        if let memorydata = memory.object(forKey: key as NSString) {
            return memorydata as Data
        }

        let path = cacheURL(forKey: key)
        if disk.fileExists(atPath: path.absoluteString),
           let data = try? Data(contentsOf: path) {
            self.store(data, forKey: key)
            return data
        } else {
            return nil
        }
    }

    func cacheURL(forKey key: Key) -> URL {
        let directoryURL = disk.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        if #available(iOS 16.0, *) {
            return directoryURL.appending(path: key)
        } else {
            return directoryURL.appendingPathComponent(key)
        }
    }

}
