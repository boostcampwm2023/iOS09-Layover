//
//  EditTagInteractor.swift
//  Layover
//
//  Created by kong on 2023/12/03.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditTagBusinessLogic {
    func fetchTags()
    func editTags(request: EditTagModels.EditTags.Request)
    func addTag(request: EditTagModels.AddTag.Request)
}

protocol EditTagDataStore {
    var tags: [String]? { get set }
}

final class EditTagInteractor: EditTagBusinessLogic, EditTagDataStore {

    var tags: [String]?

    // MARK: - Properties

    typealias Models = EditTagModels

    var presenter: EditTagPresentationLogic?

    func fetchTags() {
        guard let tags else { return }
        presenter?.presentTags(with: EditTagModels.FetchTags.Response(tags: tags))
    }

    func editTags(request: EditTagModels.EditTags.Request) {
        tags = request.editedTags
        guard let tags else { return }
        presenter?.presentEditedTags(with: EditTagModels.EditTags.Response(editedTags: tags))
    }

    func addTag(request: EditTagModels.AddTag.Request) {
        if request.tags.count >= Models.maxTagCount { return }
        tags = request.tags
        tags?.append(request.newTag)
        let response = Models.AddTag.Response(tags: tags ?? [],
                                              addedTag: request.newTag)
        presenter?.presentAddedTag(with: response)
    }

}
