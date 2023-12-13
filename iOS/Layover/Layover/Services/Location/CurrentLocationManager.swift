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

    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return locationFetcher.authorizationStatus
    }

    func startUpdatingLocation() {
        self.locationFetcher.startUpdatingLocation()
    }

    func requestWhenInUseAuthorization() {
        self.locationFetcher.requestWhenInUseAuthorization()
    }

}

extension CurrentLocationManager: LocationFetcherDelegate {
    func locationFetcher(_ fetcher: LocationFetcher, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.currentLocationCompletion?(location)
        self.currentLocationCompletion = nil
    }
}

extension CurrentLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationFetcher(manager, didUpdateLocations: locations)
    }
}
