//
//  SettingSceneViewController.swift
//  Layover
//
//  Created by 황지웅 on 11/30/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol SettingSceneDisplayLogic: AnyObject {
}

final class SettingSceneViewController: BaseViewController, SettingSceneDisplayLogic {

    // MARK: - Properties

    typealias Models = SettingSceneModels
    var router: (NSObjectProtocol & SettingSceneRoutingLogic & SettingSceneDataPassing)?
    var interactor: SettingSceneBusinessLogic?

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
        let viewController = self
        let interactor = SettingSceneInteractor()
        let presenter = SettingScenePresenter()
        let router = SettingSceneRouter()

        viewController.router = router
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
