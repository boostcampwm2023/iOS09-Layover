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
    func editTag(request: EditTagModels.EditTag.Request)
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

    func editTag(request: EditTagModels.EditTag.Request) {
        tags = request.tags
    }

}
