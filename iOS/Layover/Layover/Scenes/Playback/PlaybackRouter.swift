//
//  PlaybackRouter.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol PlaybackRoutingLogic {
    func routeToNext()
}

protocol PlaybackDataPassing {
    var dataStore: PlaybackDataStore? { get }
}

class PlaybackRouter: NSObject, PlaybackRoutingLogic, PlaybackDataPassing {

    // MARK: - Properties

    weak var viewController: PlaybackViewController?
    var dataStore: PlaybackDataStore?

    // MARK: - Routing

    func routeToNext() {
        // let destinationVC = UIStoryboard(name: "", bundle: nil).instantiateViewController(withIdentifier: "") as! NextViewController
        // var destinationDS = destinationVC.router!.dataStore!
        // passDataTo(destinationDS, from: dataStore!)
        // viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }

    // MARK: - Data Passing

    // func passDataTo(_ destinationDS: inout NextDataStore, from sourceDS: PlaybackDataStore) {
    //     destinationDS.attribute = sourceDS.attribute
    // }
}
