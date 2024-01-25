//
//  MapInteractor.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import CoreLocation
import Foundation

import OSLog

protocol MapBusinessLogic {
    func playPosts(with: MapModels.PlayPosts.Request)
    func fetchPosts() async
    func fetchPosts(latitude: Double, longitude: Double) async
    func selectVideo(with request: MapModels.SelectVideo.Request)
    func checkLocationAuthorizationOnEntry()
    func checkLocationPermissionOnUpload()
}

protocol MapDataStore {
    var postPlayStartIndex: Int? { get set }
    var posts: [Post]? { get set }
    var selectedVideoURL: URL? { get set }
}

final class MapInteractor: NSObject, MapBusinessLogic, MapDataStore {

    // MARK: - Properties

    typealias Models = MapModels
    var presenter: MapPresentationLogic?
    var videoFileWorker: VideoFileWorker?
    var worker: MapWorkerProtocol?
    var locationManager: CurrentLocationManager?

    var postPlayStartIndex: Int?
    var posts: [Post]?
    var index: Int?
    var selectedVideoURL: URL?

    func playPosts(with request: MapModels.PlayPosts.Request) {
        postPlayStartIndex = request.selectedIndex
        presenter?.presentPlaybackScene()
    }

    func fetchPosts() async {
        locationManager?.startUpdatingLocation()
        guard let coordinate = locationManager?.getCurrentLocation()?.coordinate else { return }
        let posts = await worker?.fetchPosts(latitude: coordinate.latitude,
                                             longitude: coordinate.longitude)
        guard let posts else { return }
        self.posts = posts
        let response = Models.FetchPosts.Response(posts: posts)
        await MainActor.run {
            presenter?.presentFetchedPosts(with: response)
        }
    }

    func fetchPosts(latitude: Double, longitude: Double) async {
        let posts = await worker?.fetchPosts(latitude: latitude, longitude: longitude)
        guard let posts else { return }
        self.posts = posts
        let response = Models.FetchPosts.Response(posts: posts)
        await MainActor.run {
            presenter?.presentFetchedPosts(with: response)
        }
    }

    func selectVideo(with request: Models.SelectVideo.Request) {
        selectedVideoURL = videoFileWorker?.copyToNewURL(at: request.videoURL)
    }

    func checkLocationAuthorizationOnEntry() {
        guard let authorizationStatus = locationManager?.getAuthorizationStatus() else { return }
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            presenter?.presentCurrentLocation()
        case .restricted, .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .denied:
            presenter?.presentDefaultLocation()
        @unknown default:
            return
        }
    }

    func checkLocationPermissionOnUpload() {
        guard let authorizationStatus = locationManager?.getAuthorizationStatus() else { return }
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            presenter?.presentUploadScene()
        case .restricted, .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .denied:
            presenter?.presentSetting()
        @unknown default:
            return
        }
    }

}
