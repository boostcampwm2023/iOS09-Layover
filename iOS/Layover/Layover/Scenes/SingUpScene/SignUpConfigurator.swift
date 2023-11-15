//
//  SignUpConfigurator.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

final class SignUpConfigurator: Configurator {
    typealias T = SignUpViewController

    static let shared = SignUpConfigurator()

    private init() { }

    func configure(_ viewController: SignUpViewController) {
        let viewController = viewController
        let interactor = SignUpInteractor()
        let presenter = SignUpPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
}
