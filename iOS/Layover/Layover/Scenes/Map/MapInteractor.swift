//
//  MapInteractor.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import CoreLocation
import Foundation

protocol MapBusinessLogic {
    func checkLocationAuthorizationStatus()
    func fetchVideos()
    func moveToPlaybackScene(with: MapModels.MoveToPlaybackScene.Request)
    func playPosts(with: MapModels.PlayPosts.Request)

    @discardableResult
    func fetchPosts() -> Task<[MapModels.Post], Never>

    @discardableResult
    func fetchPost(latitude: Double, longitude: Double) -> Task<[MapModels.Post], Never>
    func selectVideo(with request: MapModels.SelectVideo.Request)
}

protocol MapDataStore {
    var postPlayStartIndex: Int? { get set }
    var posts: [Post]? { get set }
//    var posts: [MapModels.Post]? { get set }
    var index: Int? { get set }
    var selectedVideoURL: URL? { get set }
}

final class MapInteractor: NSObject, MapBusinessLogic, MapDataStore {

    // MARK: - Properties

    typealias Models = MapModels
    var presenter: MapPresentationLogic?
    var videoFileWorker: VideoFileWorker?
    var worker: MapWorkerProtocol?

    private let locationManager = CLLocationManager()

    var postPlayStartIndex: Int?
    var posts: [Post]?
//    var posts: [Models.Post]?
    var index: Int?
    var selectedVideoURL: URL?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func checkLocationAuthorizationStatus() {
        checkCurrentLocationAuthorization(for: locationManager.authorizationStatus)
    }

    func fetchVideos() {
        // TODO: worker 네트워크 호출
        let dummyURLs: [URL] = ["http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8",
                                   "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8",
                                   "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8",
                                   "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8",
                                   "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8",
                                   "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8"]
            .compactMap { URL(string: $0) }
        presenter?.presentFetchedVideos(with: MapModels.FetchVideo.Response(videoURLs: dummyURLs))
    }

    func moveToPlaybackScene(with request: Models.MoveToPlaybackScene.Request) {
        posts = request.videos.map { .init(member: $0.member, board: $0.board, tag: $0.tag) }
        index = request.index
        presenter?.presentPlaybackScene()
    }

    func playPosts(with request: MapModels.PlayPosts.Request) {
        postPlayStartIndex = request.selectedIndex
        presenter?.presentPlaybackScene()
    }

    func fetchPosts() -> Task<[MapModels.Post], Never> {
        Task {
            locationManager.startUpdatingLocation()
            guard let coordinate = locationManager.location?.coordinate else { return [] }
            let posts = await worker?.fetchPosts(latitude: coordinate.latitude,
                                                 longitude: coordinate.longitude)
            guard let posts else { return [] }
            let response = Models.FetchPosts.Response(posts: posts)
            await MainActor.run {
                presenter?.presentFetchedPosts(with: response)
            }
            return posts
        }
    }

    func fetchPost(latitude: Double, longitude: Double) -> Task<[MapModels.Post], Never> {
        Task {
            let posts = await worker?.fetchPosts(latitude: latitude, longitude: longitude)
            guard let posts else { return [] }
            let response = Models.FetchPosts.Response(posts: posts)
            await MainActor.run {
                presenter?.presentFetchedPosts(with: response)
            }
            return posts
        }
    }

    func selectVideo(with request: Models.SelectVideo.Request) {
        selectedVideoURL = videoFileWorker?.copyToNewURL(at: request.videoURL)
    }

    private func checkCurrentLocationAuthorization(for status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            presenter?.presentCurrentLocation()
        case .restricted, .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            presenter?.presentDefaultLocation()
        @unknown default:
            return
        }
    }
}

extension MapInteractor: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkCurrentLocationAuthorization(for: manager.authorizationStatus)
    }
}
