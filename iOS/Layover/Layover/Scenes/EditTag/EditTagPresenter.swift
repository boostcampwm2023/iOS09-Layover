//
//  EditTagPresenter.swift
//  Layover
//
//  Created by kong on 2023/12/03.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditTagPresentationLogic {
    func presentTags(with response: EditTagModels.FetchTags.Response)
}

final class EditTagPresenter: EditTagPresentationLogic {

    // MARK: - Properties

    typealias Models = EditTagModels
    weak var viewController: EditTagDisplayLogic?

    func presentTags(with response: EditTagModels.FetchTags.Response) {
        viewController?.displayTags(viewModel: EditTagModels.FetchTags.ViewModel(tags: response.tags))
    }

}
