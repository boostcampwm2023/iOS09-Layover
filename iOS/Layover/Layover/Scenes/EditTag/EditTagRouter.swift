//
//  EditTagRouter.swift
//  Layover
//
//  Created by kong on 2023/12/03.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditTagRoutingLogic {
    func routeToNext()
}

protocol EditTagDataPassing {
    var dataStore: EditTagDataStore? { get }
}

class EditTagRouter: NSObject, EditTagRoutingLogic, EditTagDataPassing {

    // MARK: - Properties

    weak var viewController: EditTagViewController?
    var dataStore: EditTagDataStore?

    // MARK: - Routing

    func routeToNext() {
        // let destinationVC = UIStoryboard(name: "", bundle: nil).instantiateViewController(withIdentifier: "") as! NextViewController
        // var destinationDS = destinationVC.router!.dataStore!
        // passDataTo(destinationDS, from: dataStore!)
        // viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }

}
