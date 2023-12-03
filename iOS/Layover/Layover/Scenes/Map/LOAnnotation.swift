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
    let thumbnailURL: URL

    init(coordinate: CLLocationCoordinate2D, thumbnailURL: URL) {
        self.coordinate = coordinate
        self.thumbnailURL = thumbnailURL
    }
}
