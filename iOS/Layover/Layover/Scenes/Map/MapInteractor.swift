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
    func selectVideo(with request: MapModels.SelectVideo.Request)
}

protocol MapDataStore {
    var postPlayStartIndex: Int? { get set }
    var posts: [Post]? { get set }
    var index: Int? { get set }
    var selectedVideoURL: URL? { get set }
}

final class MapInteractor: NSObject, MapBusinessLogic, MapDataStore {

    // MARK: - Properties

    typealias Models = MapModels
    var presenter: MapPresentationLogic?
    var videoFileWorker: VideoFileWorker?

    private let locationManager = CLLocationManager()
    private var latitude: Double?
    private var longitude: Double?

    var postPlayStartIndex: Int?
    var posts: [Post]?
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
        presenter?.presentFetchedVideos(with: MapModels.FetchVideo.Reponse(videoURLs: dummyURLs))
    }

    func moveToPlaybackScene(with request: Models.MoveToPlaybackScene.Request) {
        posts = request.videos
        index = request.index
        presenter?.presentPlaybackScene()
    }

    func playPosts(with request: MapModels.PlayPosts.Request) {
        postPlayStartIndex = request.selectedIndex
        presenter?.presentPlaybackScene()
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            longitude = location.coordinate.longitude
            latitude = location.coordinate.latitude
        }
    }

}
