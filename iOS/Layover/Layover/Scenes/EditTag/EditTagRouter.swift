//
//  EditTagRouter.swift
//  Layover
//
//  Created by kong on 2023/12/03.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditTagRoutingLogic {
    func routeToBack()
}

protocol EditTagDataPassing {
    var dataStore: EditTagDataStore? { get }
}

final class EditTagRouter: NSObject, EditTagRoutingLogic, EditTagDataPassing {

    // MARK: - Properties

    weak var viewController: EditTagViewController?

    var dataStore: EditTagDataStore?

    // MARK: - Routing

    func routeToBack() {
        guard let presentingViewController = viewController?.presentingViewController as? UITabBarController,
              let selectedViewController = presentingViewController.selectedViewController as? UINavigationController,
              let previousViewController = selectedViewController.viewControllers.last as? UploadPostViewController,
              var destination = previousViewController.router?.dataStore
        else { return }
        destination.tags = dataStore?.tags
        viewController?.dismiss(animated: true)
    }

}
