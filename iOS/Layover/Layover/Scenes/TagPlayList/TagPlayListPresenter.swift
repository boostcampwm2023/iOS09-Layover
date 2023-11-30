//
//  TagPlayListPresenter.swift
//  Layover
//
//  Created by 김인환 on 11/29/23.
//  Copyright (c) 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol TagPlayListPresentationLogic {
    func presentPlayList(response: TagPlayListModels.FetchPosts.Response)
}

final class TagPlayListPresenter: TagPlayListPresentationLogic {

    // MARK: - Properties
    typealias Model = TagPlayListModels
    weak var viewController: TagPlayListDisplayLogic?

    // MARK: - Methods

    func presentPlayList(response: TagPlayListModels.FetchPosts.Response) {
        let displayedPosts = response.post
        viewController?.displayPlayList(viewModel: Model.FetchPosts.ViewModel(displayedPost: displayedPosts))
    }
}
