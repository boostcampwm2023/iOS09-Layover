//
//  MapPresenter.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol MapPresentationLogic {
    func presentCurrentLocation()
    func presentDefaultLocation()
    func presentFetchedVideos(response: MapModels.FetchVideo.Reponse)
}

final class MapPresenter: MapPresentationLogic {

    // MARK: - Properties

    typealias Models = MapModels
    weak var viewController: MapDisplayLogic?

    func presentCurrentLocation() {
        // TODO: 현재 위치 사용 가능
    }

    func presentDefaultLocation() {
        // TODO: 위치 관련 기능 사용 불가, 디폴트 위치로 이동
    }

    func presentFetchedVideos(response: MapModels.FetchVideo.Reponse) {
        viewController?.displayFetchedVideos(viewModel: MapModels.FetchVideo.ViewModel(videoDataSources: response.videoURLs.map { .init(videoURLs: $0) }))
    }
}
