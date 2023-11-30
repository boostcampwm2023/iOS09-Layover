//
//  HomeInteractor.swift
//  Layover
//
//  Created by 김인환 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol HomeBusinessLogic {
    func fetchVideos(with: HomeModels.FetchPosts.Request)
    func moveToPlaybackScene(with: HomeModels.MoveToPlaybackScene.Request)
    func selectVideo(with request: HomeModels.SelectVideo.Request)
}

protocol HomeDataStore {
    var videos: [Post]? { get set }
    var selectedVideoURL: URL? { get set }
}

final class HomeInteractor: HomeDataStore {

    // MARK: - Properties

    typealias Models = HomeModels

    var videoFileWorker: VideoFileWorkerProtocol?
    var homeWorker: HomeWorkerProtocol?
    var presenter: HomePresentationLogic?

    // MARK: - DataStore

    var videos: [Post]?
    var selectedVideoURL: URL?

    func selectVideo(with request: Models.SelectVideo.Request) {
        selectedVideoURL = videoFileWorker?.copyToNewURL(at: request.videoURL)
    }
}

// MARK: - Use Case

extension HomeInteractor: HomeBusinessLogic {
    func fetchVideos(with request: Models.FetchPosts.Request) {
        Task {
            guard let post = await self.homeWorker?.fetchHomePost() else { return }
            await MainActor.run {
                self.presenter?.presentPosts(with: Models.FetchPosts.Response(posts: post))
            }
        }
    }

    func moveToPlaybackScene(with request: Models.MoveToPlaybackScene.Request) {
        videos = request.videos
        presenter?.presentPlaybackScene()
    }
}
