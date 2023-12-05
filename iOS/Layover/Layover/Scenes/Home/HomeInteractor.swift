//
//  HomeInteractor.swift
//  Layover
//
//  Created by 김인환 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol HomeBusinessLogic {
    @discardableResult
    func fetchPosts(with request: HomeModels.FetchPosts.Request) -> Task<Bool, Never>
    @discardableResult
    func fetchThumbnailImageData(with request: HomeModels.FetchThumbnailImageData.Request) -> Task<Bool, Never>
    func playPosts(with request: HomeModels.PlayPosts.Request)
    func selectVideo(with request: HomeModels.SelectVideo.Request)
    func showTagPlayList(with request: HomeModels.ShowTagPlayList.Request)
}

protocol HomeDataStore {
    var posts: [Post]? { get set }
    var postPlayStartIndex: Int? { get set }
    var selectedVideoURL: URL? { get set }

    var selectedTag: String? { get set }
}

final class HomeInteractor: HomeDataStore {

    // MARK: - Properties

    typealias Models = HomeModels

    var videoFileWorker: VideoFileWorkerProtocol?
    var homeWorker: HomeWorkerProtocol?
    var presenter: HomePresentationLogic?

    // MARK: - DataStore

    var posts: [Post]?
    var postPlayStartIndex: Int?
    var selectedVideoURL: URL?
    var selectedTag: String?
}

// MARK: - Use Case

extension HomeInteractor: HomeBusinessLogic {
    @discardableResult
    func fetchPosts(with request: Models.FetchPosts.Request) -> Task<Bool, Never> {
        Task {
            guard let posts = await homeWorker?.fetchPosts() else { return false }
            let response = Models.FetchPosts.Response(posts: posts)

            await MainActor.run {
                self.posts = posts
                presenter?.presentPosts(with: response)
            }

            return true
        }
    }

    @discardableResult
    func fetchThumbnailImageData(with request: HomeModels.FetchThumbnailImageData.Request) -> Task<Bool, Never> {
        Task {
            guard let imageData = await homeWorker?.fetchImageData(of: request.imageURL) else { return false }
            let response = Models.FetchThumbnailImageData.Response(imageData: imageData,
                                                                   indexPath: request.indexPath)

            await MainActor.run {
                presenter?.presentThumbnailImage(with: response)
            }

            return true
        }
    }

    func playPosts(with request: HomeModels.PlayPosts.Request) {
        postPlayStartIndex = request.selectedIndex
        presenter?.presentPlaybackScene(with: Models.PlayPosts.Response())
    }

    func selectVideo(with request: Models.SelectVideo.Request) {
        selectedVideoURL = videoFileWorker?.copyToNewURL(at: request.videoURL)
    }

    func showTagPlayList(with request: HomeModels.ShowTagPlayList.Request) {
        selectedTag = request.tag
        presenter?.presentTagPlayList(with: Models.ShowTagPlayList.Response())
    }
}
