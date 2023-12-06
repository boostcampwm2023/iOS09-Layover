//
//  SettingRouter.swift
//  Layover
//
//  Created by 김인환 on 12/6/23.
//  Copyright (c) 2023 CodeBomber. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SafariServices

protocol SettingRoutingLogic {
    func showSafariViewController(url: URL)
}

protocol SettingDataPassing {
    var dataStore: SettingDataStore? { get }
}

final class SettingRouter: SettingRoutingLogic, SettingDataPassing {

    // MARK: - Properties

    weak var viewController: SettingViewController?
    var dataStore: SettingDataStore?

    // MARK: - Methods

    func showSafariViewController(url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        viewController?.present(safariViewController, animated: true, completion: nil)
    }
}
