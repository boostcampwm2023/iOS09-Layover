//
//  EditProfileViewController.swift
//  Layover
//
//  Created by kong on 2023/11/27.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditProfileDisplayLogic: AnyObject {

}

final class EditProfileViewController: UIViewController, EditProfileDisplayLogic {

    // MARK: - Properties

    typealias Models = EditProfileModels
    var router: (NSObjectProtocol & EditProfileRoutingLogic & EditProfileDataPassing)?
    var interactor: EditProfileBusinessLogic?

    // MARK: - Object Lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
