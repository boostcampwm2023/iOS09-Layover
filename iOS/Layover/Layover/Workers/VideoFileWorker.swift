//
//  VideoFileWorker.swift
//  Layover
//
//  Created by kong on 2023/11/30.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import OSLog

protocol VideoFileWorkerProtocol {
    func copyToNewURL(at videoURL: URL) -> URL?
    func delete(at videoURL: URL) -> Bool
}

final class VideoFileWorker: VideoFileWorkerProtocol {

    // MARK: - Properties

    private let fileManager: FileManager
    private let directoryPath: String
    private let fileName: String

    // MARK: - Intializer

    init(fileManager: FileManager = FileManager.default,
         directoryPath: String = "layover",
         fileName: String = "\(Int(Date().timeIntervalSince1970))") {
        self.fileManager = fileManager
        self.directoryPath = directoryPath
        self.fileName = fileName

    }

    // MARK: - Methods

    func copyToNewURL(at videoURL: URL) -> URL? {
        let temporaryDirectory = fileManager.temporaryDirectory
        let path = "\(directoryPath)/\(fileName).\(videoURL.pathExtension)"

        let newURL = temporaryDirectory.appending(path: path)
        do {
            if fileManager.fileExists(atPath: newURL.path()) {
                delete(at: newURL)
            }
            try fileManager.createDirectory(at: temporaryDirectory.appending(path: directoryPath),
                                            withIntermediateDirectories: true)
            try fileManager.copyItem(at: videoURL as URL, to: newURL)
            return newURL
        } catch {
            os_log(.error, log: .data, "%@", error.localizedDescription)
            return nil
        }
    }

    @discardableResult
    func delete(at videoURL: URL) -> Bool {
        do {
            try fileManager.removeItem(at: videoURL)
            return true
        } catch {
            return false
        }
    }
}
