//
//  VideoFileWorker.swift
//  Layover
//
//  Created by kong on 2023/11/30.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

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
         fileName: String = "\(Date().timeIntervalSince1970)") {
        self.fileManager = fileManager
        self.directoryPath = directoryPath
        self.fileName = fileName

    }

    // MARK: - Methods

    func copyToNewURL(at videoURL: URL) -> URL? {
        let documentsURL = FileManager.default.temporaryDirectory
        let fileName = "\(directoryPath)/\(directoryPath).\(videoURL.pathExtension)"
        let newURL = documentsURL.appending(path: fileName)
        do {
            if fileManager.fileExists(atPath: newURL.path()) {
                delete(at: newURL)
            }
            try FileManager.default.copyItem(at: videoURL as URL, to: newURL)
            return newURL
        } catch {
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
