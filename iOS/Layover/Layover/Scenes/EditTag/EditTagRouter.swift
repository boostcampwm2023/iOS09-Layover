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
        guard let presentingViewController = viewController?.presentingViewController as? UINavigationController,
              let tabbarViewController = presentingViewController.viewControllers.last as? UITabBarController,
              let selectedViewcontroller = tabbarViewController.selectedViewController as? UINavigationController,
              let previousViewController = selectedViewcontroller.viewControllers.last as? UploadPostViewController,
              let dataStore, var destination = previousViewController.router?.dataStore
        else { return }
        passDataToBack(source: dataStore, destination: &destination)
        viewController?.dismiss(animated: true)
    }

    private func passDataToBack(source: EditTagDataStore, destination: inout UploadPostDataStore) {
        destination.tags = source.tags
    }

}
