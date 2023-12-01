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
        // let destinationVC = UIStoryboard(name: "", bundle: nil).instantiateViewController(withIdentifier: "") as! NextViewController
        // var destinationDS = destinationVC.router!.dataStore!
        // passDataTo(destinationDS, from: dataStore!)
        // viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }

    // MARK: - Data Passing

    // func passDataTo(_ destinationDS: inout NextDataStore, from sourceDS: UploadPostDataStore) {
    //     destinationDS.attribute = sourceDS.attribute
    // }
}
