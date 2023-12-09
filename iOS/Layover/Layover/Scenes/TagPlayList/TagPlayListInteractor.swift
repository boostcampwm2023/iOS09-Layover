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
    func fetchPlayList(request: TagPlayListModels.FetchPosts.Request) -> Task<Bool, Never>
    func fetchMorePlayList(request: TagPlayListModels.FetchPosts.Request) -> Task<Bool, Never>
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

    private var fetchPostsPage = 1
    private var canFetchMorePosts = true

    // MARK: - DataStore

    var titleTag: String?
    var posts: [Post] = []

    // MARK: - TagPlayListBusinessLogic

    func fetchTitleTag(request: TagPlayListModels.FetchTitleTag.Request) {
        guard let titleTag = titleTag else { return }
        presenter?.presentTitleTag(response: Models.FetchTitleTag.Response(titleTag: titleTag))
    }

    func fetchPlayList(request: Models.FetchPosts.Request) -> Task<Bool, Never> {
        Task {
            guard let titleTag = titleTag,
                  let posts = await worker?.fetchPlayList(of: titleTag, at: fetchPostsPage) else { return false }
            self.posts.append(contentsOf: posts)
            fetchPostsPage += 1
            canFetchMorePosts = !posts.isEmpty

            let responsePosts = await transformDisplayedPost(with: posts)

            await MainActor.run {
                presenter?.presentPlayList(response: Models.FetchPosts.Response(post: responsePosts))
            }

            return true
        }
    }

    func fetchMorePlayList(request: Models.FetchPosts.Request) -> Task<Bool, Never> {
        Task {
            guard canFetchMorePosts,
                  let titleTag = titleTag,
                  let posts = await worker?.fetchPlayList(of: titleTag, at: fetchPostsPage) else { return false }
            self.posts.append(contentsOf: posts)
            fetchPostsPage += 1
            canFetchMorePosts = !posts.isEmpty

            let responsePosts = await transformDisplayedPost(with: posts)

            await MainActor.run {
                presenter?.presentMorePlayList(response: Models.FetchMorePosts.Response(post: responsePosts))
            }

            return true
        }
    }

    private func transformDisplayedPost(with posts: [Post]) async -> [Models.DisplayedPost] {
        return await withTaskGroup(of: Models.DisplayedPost.self) { group -> [Models.DisplayedPost] in
            for post in posts {
                if let thumbnailImageURL = post.board.thumbnailImageURL {
                    group.addTask {
                        let thumbnailImageData = await self.worker?.loadImageData(from: thumbnailImageURL)
                        return Models.DisplayedPost(identifier: post.board.identifier,
                                                    thumbnailImageData: thumbnailImageData,
                                                    title: post.board.title)
                    }
                }
            }

            var result = [Models.DisplayedPost]()
            for await post in group {
                result.append(post)
            }

            return result
        }
    }
}
