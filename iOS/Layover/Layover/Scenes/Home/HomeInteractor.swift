//
//  HomeInteractor.swift
//  Layover
//
//  Created by 김인환 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol HomeBusinessLogic {
    func fetchVideos(with: HomeModels.CarouselVideos.Request)
    func selectVideo(with request: HomeModels.SelectVideo.Request)
}

protocol HomeDataStore {
    var selectedVideoURL: URL? { get set }
}

final class HomeInteractor: HomeDataStore {

    // MARK: - Properties

    typealias Models = HomeModels

    var videoFileWorker: VideoFileWorkerProtocol?
    var presenter: HomePresentationLogic?

    var selectedVideoURL: URL?

    func selectVideo(with request: Models.SelectVideo.Request) {
        selectedVideoURL = videoFileWorker?.copyToNewURL(at: request.videoURL)
    }

}

// MARK: - Use Case

extension HomeInteractor: HomeBusinessLogic {
    func fetchVideos(with request: Models.CarouselVideos.Request) {
        let response = Models.CarouselVideos.Response(videoURLs: [
            URL(string: "https://assets.afcdn.com/video49/20210722/v_645516.m3u8")!,
            URL(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")!,
            URL(string: "https://sample.vodobox.net/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8")!,
            URL(string: "https://playertest.longtailvideo.com/adaptive/wowzaid3/playlist.m3u8")!,
            URL(string: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8")!
        ])
        presenter?.presentVideoURL(with: response)
    }
}
