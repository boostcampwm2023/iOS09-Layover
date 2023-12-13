//
//  CurrentLocationManager.swift
//  Layover
//
//  Created by kong on 2023/12/12.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import CoreLocation

final class CurrentLocationManager: NSObject {

    typealias LocationCompletion = ((CLLocation) -> Void)

    private var locationFetcher: LocationFetcher
    var currentLocationCompletion: LocationCompletion?
    var authrizationCompletion: ((CLAuthorizationStatus) -> Void)?

    init(locationFetcher: LocationFetcher = CLLocationManager()) {
        self.locationFetcher = locationFetcher
        super.init()
        self.locationFetcher.locationFetcherDelegate = self
        self.locationFetcher.desiredAccuracy = kCLLocationAccuracyBest
    }

    func getCurrentLocation() -> CLLocation? {
        startUpdatingLocation()
        guard let space = locationFetcher.location?.coordinate else { return nil }
        return CLLocation(latitude: space.latitude, longitude: space.longitude)
    }

    func startUpdatingLocation() {
        self.locationFetcher.startUpdatingLocation()
    }

}

extension CurrentLocationManager: LocationFetcherDelegate {
    func locationFetcher(_ fetcher: LocationFetcher, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.currentLocationCompletion?(location)
        self.currentLocationCompletion = nil
    }

    func locationFetcher(_ fetcher: LocationFetcher, didChangeAuthorization authorization: CLAuthorizationStatus) {
        self.authrizationCompletion?(authorization)
        self.authrizationCompletion = nil
    }
}

extension CurrentLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationFetcher(manager, didUpdateLocations: locations)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.locationFetcher(manager, didChangeAuthorization: manager.authorizationStatus)
    }
}
