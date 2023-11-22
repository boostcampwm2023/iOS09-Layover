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
}

protocol HomeDataStore {

}

final class HomeInteractor: HomeDataStore {

    // MARK: - Properties

    typealias Models = HomeModels

    var presenter: HomePresentationLogic?
}

// MARK: - Use Case

extension HomeInteractor: HomeBusinessLogic {
    func fetchVideos(with request: Models.CarouselVideos.Request) {
        let response = Models.CarouselVideos.Response(videoURLs: [
            URL(string: "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8")!,
            URL(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")!
        ])
        presenter?.presentVideoURL(with: response)
    }
}
