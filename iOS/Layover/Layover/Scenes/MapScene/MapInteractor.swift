//
//  MapInteractor.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol MapBusinessLogic {

}

protocol MapDataStore { }

final class MapInteractor: MapBusinessLogic, MapDataStore {

    // MARK: - Properties

    typealias Models = MapModels

    var presenter: MapPresentationLogic?

}
