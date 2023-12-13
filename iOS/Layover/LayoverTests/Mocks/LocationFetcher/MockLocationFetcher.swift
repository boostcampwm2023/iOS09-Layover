//
//  MockLocationFetcher.swift
//  LayoverTests
//
//  Created by kong on 2023/12/13.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import CoreLocation

@testable import Layover

final class MockLocationFetcher: LocationFetcher {
    var location: CLLocation?
    var locationFetcherDelegate: Layover.LocationFetcherDelegate?
    var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest

    func requestLocation() { }

    func startUpdatingLocation() {
        location = CLLocation(latitude: 37.498206, longitude: 127.02761)
        guard let location else { return }
        locationFetcherDelegate?.locationFetcher(self, didUpdateLocations: [location])
    }

    func requestWhenInUseAuthorization() { }

    func requestAlwaysAuthorization() { }
}
