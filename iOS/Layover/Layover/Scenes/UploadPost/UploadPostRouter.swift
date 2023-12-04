//
//  UploadPostRouter.swift
//  Layover
//
//  Created by kong on 2023/12/01.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol UploadPostRoutingLogic {
    func routeToNext()
}

protocol UploadPostDataPassing {
    var dataStore: UploadPostDataStore? { get }
}

class UploadPostRouter: NSObject, UploadPostRoutingLogic, UploadPostDataPassing {

    // MARK: - Properties

    weak var viewController: UploadPostViewController?
    var dataStore: UploadPostDataStore?

    // MARK: - Routing

    func routeToNext() {
        let nextViewController = EditTagViewController()
        guard let source = dataStore,
              var destination = nextViewController.router?.dataStore
        else { return }

        destination.tags = source.tags
        nextViewController.modalPresentationStyle = .fullScreen
        viewController?.present(nextViewController, animated: true)
    }

}
