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
}

protocol MapDataStore { }

final class MapInteractor: NSObject, MapBusinessLogic, MapDataStore {

    // MARK: - Properties

    typealias Models = MapModels

    private let locationManager = CLLocationManager()

    private var latitude: Double?

    private var longitude: Double?

    var presenter: MapPresentationLogic?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func checkLocationAuthorizationStatus() {
        checkCurrentLocationAuthorization(for: locationManager.authorizationStatus)
    }

    func fetchVideos() {
        // TODO: worker 네트워크 호출
        let dummyData: [String] = ["http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8",
                                   "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8",
                                   "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8",
                                   "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8",
                                   "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8",
                                   "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8"]
        presenter?.presentFetchedVideos(response: MapModels.FetchVideo.Reponse(videoURLs: dummyData))
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
