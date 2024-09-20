//
//  LocationFetcher.swift
//  Layover
//
//  Created by kong on 2023/12/12.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import CoreLocation

protocol LocationFetcherDelegate: AnyObject {
    func locationFetcher(_ fetcher: LocationFetcher, didUpdateLocations locations: [CLLocation])
}

protocol LocationFetcher {
    var location: CLLocation? { get }
    var locationFetcherDelegate: LocationFetcherDelegate? { get set }
    var authorizationStatus: CLAuthorizationStatus { get }
    var desiredAccuracy: CLLocationAccuracy { get set }

    func requestLocation()
    func startUpdatingLocation()
    func requestWhenInUseAuthorization()
}

extension CLLocationManager: LocationFetcher {
    var locationFetcherDelegate: LocationFetcherDelegate? {
        get {
            return delegate as? LocationFetcherDelegate
        }
        set {
            delegate = newValue as? CLLocationManagerDelegate
        }
    }
}
