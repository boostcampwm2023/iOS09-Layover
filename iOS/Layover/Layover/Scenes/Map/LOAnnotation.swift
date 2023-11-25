//
//  LOAnnotation.swift
//  Layover
//
//  Created by kong on 2023/11/26.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import MapKit

final class LOAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var thumnailImage: URL

    init(coordinate: CLLocationCoordinate2D, thumnailImage: URL) {
        self.coordinate = coordinate
        self.thumnailImage = thumnailImage
    }
}
