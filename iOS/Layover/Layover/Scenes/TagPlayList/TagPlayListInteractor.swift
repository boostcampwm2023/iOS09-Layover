//
//  TagPlayListInteractor.swift
//  Layover
//
//  Created by 김인환 on 11/29/23.
//  Copyright (c) 2023 CodeBomber. All rights reserved.
//

import UIKit
import OSLog

protocol TagPlayListBusinessLogic {
    func fetchPlayList(request: TagPlayListModels.FetchPosts.Request)
}

protocol TagPlayListDataStore {
    var titleTag: String? { get set }
}

final class TagPlayListInteractor: TagPlayListBusinessLogic, TagPlayListDataStore {
    // MARK: - Properties

    typealias Model = TagPlayListModels
    var presenter: TagPlayListPresentationLogic?
    var worker: TagPlayListWorkerProtocol?

    // MARK: - DataStore

    var titleTag: String?

    // MARK: - TagPlayListBusinessLogic

    func fetchPlayList(request: Model.FetchPosts.Request) {
        Task {
            guard let posts = await worker?.fetchPlayList(by: request.tag) else { return }

            do {
                let responsePosts = try await posts.concurrentMap {
                    if let imageURL = $0.board.thumbnailImageURL,
                       let imageData = await self.worker?.loadImageData(from: imageURL) {
                        return Model.DisplayedPost(thumbnailImageData: imageData, title: $0.board.title)
                    } else {
                        return nil
                    }
                }.compactMap { $0 }
                await MainActor.run {
                    presenter?.presentPlayList(response: Model.FetchPosts.Response(post: responsePosts))
                }
            } catch {
                os_log(.error, log: .default, "Error: %@", error.localizedDescription)
            }
        }
    }
}
