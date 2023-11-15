//
//  MapPresenter.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol MapPresentationLogic {

}

final class MapPresenter: MapPresentationLogic {

    // MARK: - Properties

    typealias Models = MapModels
    weak var viewController: MapDisplayLogic?

}
