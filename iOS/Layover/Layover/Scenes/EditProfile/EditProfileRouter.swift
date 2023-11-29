//
//  EditProfileRouter.swift
//  Layover
//
//  Created by kong on 2023/11/27.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditProfileRoutingLogic {

}

protocol EditProfileDataPassing {
    var dataStore: EditProfileDataStore? { get }
}

final class EditProfileRouter: NSObject, EditProfileRoutingLogic, EditProfileDataPassing {

    // MARK: - Properties

    weak var viewController: EditProfileViewController?
    var dataStore: EditProfileDataStore?

    // MARK: - Routing

}
