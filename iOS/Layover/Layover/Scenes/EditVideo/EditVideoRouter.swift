//
//  EditVideoRouter.swift
//  Layover
//
//  Created by kong on 2023/11/29.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditVideoRoutingLogic {
    func routeToNext()
}

protocol EditVideoDataPassing {
    var dataStore: EditVideoDataStore? { get }
}

final class EditVideoRouter: NSObject, EditVideoRoutingLogic, EditVideoDataPassing {

    // MARK: - Properties

    weak var viewController: EditVideoViewController?
    var dataStore: EditVideoDataStore?

    // MARK: - Routing

    func routeToNext() {
        let nextViewController = UploadPostViewController()
        guard let source = dataStore,
              var destination = nextViewController.router?.dataStore
        else { return }

        // Data Passing
        destination.videoURL = source.videoURL
        destination.isMuted = source.isMuted
        nextViewController.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(nextViewController, animated: true)
    }

}
