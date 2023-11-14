//
//  LoginRouter.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import UIKit

protocol LoginRoutingLogic {
    func routeToNext()
}

protocol LoginDataPassing {
    var dataStore: LoginDataStore? { get }
}

class LoginRouter: NSObject, LoginRoutingLogic, LoginDataPassing {

    // MARK: - Properties

    weak var viewController: LoginViewController?
    var dataStore: LoginDataStore?

    // MARK: - Routing

    func routeToNext() {
        // let destinationVC = UIStoryboard(name: "", bundle: nil).instantiateViewController(withIdentifier: "") as! NextViewController
        // var destinationDS = destinationVC.router!.dataStore!
        // passDataTo(destinationDS, from: dataStore!)
        // viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }

    // MARK: - Data Passing

    // func passDataTo(_ destinationDS: inout NextDataStore, from sourceDS: LoginDataStore) {
    //     destinationDS.attribute = sourceDS.attribute
    // }
}
