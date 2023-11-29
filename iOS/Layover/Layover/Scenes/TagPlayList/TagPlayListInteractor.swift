//
//  TagPlayListInteractor.swift
//  Layover
//
//  Created by 김인환 on 11/29/23.
//  Copyright (c) 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol TagPlayListBusinessLogic {
    func fetchPlayList(request: TagPlayListModels.FetchPosts.Request)
}

protocol TagPlayListDataStore {
    var titleTag: String? { get set }
}

final class TagPlayListInteractor: TagPlayListBusinessLogic, TagPlayListDataStore {
    // MARK: - Properties

    typealias Model = TagPlayListModels
    var presenter: TagPlayListPresentationLogic?
    var worker: TagPlayListWorkerProtocol?

    // MARK: - DataStore

    var titleTag: String?

    // MARK: - TagPlayListBusinessLogic

    func fetchPlayList(request: Model.FetchPosts.Request) {
        Task {
            guard let post = await worker?.fetchPlayList(by: request.tag) else { return }
            await MainActor.run {
                presenter?.presentPlayList(response: Model.FetchPosts.Response(post: post))
            }
        }
    }
}
