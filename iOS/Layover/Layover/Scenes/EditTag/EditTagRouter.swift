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

class EditTagRouter: NSObject, EditTagRoutingLogic, EditTagDataPassing {

    // MARK: - Properties

    weak var viewController: EditTagViewController?
    var dataStore: EditTagDataStore?

    // MARK: - Routing

    func routeToBack() {
        let destination = viewController?.presentingViewController as? UploadPostViewController
        var destinationDataStore = destination?.router?.dataStore

        // data passing
        viewController?.navigationController?.popViewController(animated: true)
    }

}
