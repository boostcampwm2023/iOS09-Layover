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
    func presentEditedTags(with response: EditTagModels.EditTags.Response)
    func presentAddedTag(with response: EditTagModels.AddTag.Response)
}

final class EditTagPresenter: EditTagPresentationLogic {

    // MARK: - Properties

    typealias Models = EditTagModels
    weak var viewController: EditTagDisplayLogic?

    func presentTags(with response: EditTagModels.FetchTags.Response) {
        let viewModel = Models.FetchTags.ViewModel(tags: response.tags,
                                                   tagCountDescription: "\(response.tags.count)/\(Models.maxTagCount)")
        viewController?.displayTags(viewModel: viewModel)
    }

    func presentEditedTags(with response: EditTagModels.EditTags.Response) {
        let viewModel = EditTagModels.EditTags.ViewModel(tagCountDescription: "\(response.editedTags.count)/\(Models.maxTagCount)")
        viewController?.displayEditedTags(viewModel: viewModel)
    }

    func presentAddedTag(with response: EditTagModels.AddTag.Response) {
        let viewModel = Models.AddTag.ViewModel(addedTag: response.addedTag,
                                                tagCountDescription: "\(response.tags.count)/\(Models.maxTagCount)")
        viewController?.displayAddedTag(viewModel: viewModel)
    }

}
