//
//  SettingPresenter.swift
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

protocol SettingPresentationLogic {
    func presentTableView(with response: SettingModels.ConfigureTableView.Response)
}

final class SettingPresenter: SettingPresentationLogic {

    // MARK: - Properties

    typealias Models = SettingModels
    weak var viewController: SettingDisplayLogic?

    // MARK: - Methods

    func presentTableView(with response: Models.ConfigureTableView.Response) {
        let versionNumber = response.versionNumber
        let versionSectionItem = Models.SectionItem(title: .version,
                                                    secondaryText: versionNumber)
        let versionSection = Models.TableSection(sectionTitle: .system, items: [versionSectionItem])
        let viewModel = Models.ConfigureTableView.ViewModel(tableViewSections: [
            Models.policySection,
            versionSection,
            Models.signOutSection
        ])
        viewController?.displayTableView(viewModel: viewModel)
    }
}
