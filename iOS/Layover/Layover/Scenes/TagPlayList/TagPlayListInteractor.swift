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
    func fetchTitleTag(request: TagPlayListModels.FetchTitleTag.Request)
    func fetchPlayList(request: TagPlayListModels.FetchPosts.Request)
}

protocol TagPlayListDataStore {
    var titleTag: String? { get set }
    var posts: [Post] { get set }
}

final class TagPlayListInteractor: TagPlayListBusinessLogic, TagPlayListDataStore {
    // MARK: - Properties

    typealias Models = TagPlayListModels
    var presenter: TagPlayListPresentationLogic?
    var worker: TagPlayListWorkerProtocol?

    // MARK: - DataStore

    var titleTag: String? = "몰라요"
    var posts: [Post] = []

    // MARK: - TagPlayListBusinessLogic

    func fetchTitleTag(request: TagPlayListModels.FetchTitleTag.Request) {
        guard let titleTag = titleTag else { return }
        presenter?.presentTitleTag(response: Models.FetchTitleTag.Response(titleTag: titleTag))
    }

    func fetchPlayList(request: Models.FetchPosts.Request) {
        Task {
            guard let titleTag = titleTag,
                  let posts = await worker?.fetchPlayList(by: titleTag) else { return }
            self.posts = posts
            do {
                let responsePosts = try await posts.concurrentMap {
                    if let imageURL = $0.board.thumbnailImageURL,
                       let imageData = await self.worker?.loadImageData(from: imageURL) {
                        return Models.DisplayedPost(thumbnailImageData: imageData, title: $0.board.title)
                    } else {
                        return nil
                    }
                }.compactMap { $0 }
                await MainActor.run {
                    presenter?.presentPlayList(response: Models.FetchPosts.Response(post: responsePosts))
                }
            } catch {
                os_log(.error, log: .default, "Error: %@", error.localizedDescription)
            }
        }
    }
}
