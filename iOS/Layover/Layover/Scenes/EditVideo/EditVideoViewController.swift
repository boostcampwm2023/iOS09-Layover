//
//  EditVideoViewController.swift
//  Layover
//
//  Created by kong on 2023/11/29.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditVideoDisplayLogic: AnyObject {
    func displayVideo()
}

final class EditVideoViewController: UIViewController {

    // MARK: - Properties

    typealias Models = EditVideoModels
    var router: (NSObjectProtocol & EditVideoRoutingLogic & EditVideoDataPassing)?
    var interactor: EditVideoBusinessLogic?

    // MARK: - Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        EditVideoConfigurator.shared.configure(self)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}


extension EditVideoViewController: EditVideoDisplayLogic {

    func displayVideo() {

    }

}
