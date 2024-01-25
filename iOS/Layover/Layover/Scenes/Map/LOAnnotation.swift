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
    let boardID: Int
    let thumbnailImageURL: URL?

    init(coordinate: CLLocationCoordinate2D,
         boardID: Int,
         thumbnailImageURL: URL?) {
        self.coordinate = coordinate
        self.boardID = boardID
        self.thumbnailImageURL = thumbnailImageURL
    }

}
