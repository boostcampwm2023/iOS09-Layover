//
//  EditProfileRouter.swift
//  Layover
//
//  Created by kong on 2023/11/27.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditProfileRoutingLogic {
    func routeToNext()
}

protocol EditProfileDataPassing {
    var dataStore: EditProfileDataStore? { get }
}

final class EditProfileRouter: NSObject, EditProfileRoutingLogic, EditProfileDataPassing {

    // MARK: - Properties

    weak var viewController: EditProfileViewController?
    var dataStore: EditProfileDataStore?

    // MARK: - Routing

    func routeToNext() {
        // let destinationVC = UIStoryboard(name: "", bundle: nil).instantiateViewController(withIdentifier: "") as! NextViewController
        // var destinationDS = destinationVC.router!.dataStore!
        // passDataTo(destinationDS, from: dataStore!)
        // viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }

}
