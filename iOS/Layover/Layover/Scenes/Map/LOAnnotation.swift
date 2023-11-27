//
//  LOAnnotation.swift
//  Layover
//
//  Created by kong on 2023/11/26.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import MapKit

final class LOAnnotation: NSObject, MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D
    let thumnailURL: URL

    init(coordinate: CLLocationCoordinate2D, thumnailURL: URL) {
        self.coordinate = coordinate
        self.thumnailURL = thumnailURL
    }
}
