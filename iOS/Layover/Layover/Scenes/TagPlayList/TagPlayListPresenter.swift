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
    func presentMorePlayList(response: TagPlayListModels.FetchMorePosts.Response)
    func presentTitleTag(response: TagPlayListModels.FetchTitleTag.Response)
}

final class TagPlayListPresenter: TagPlayListPresentationLogic {

    // MARK: - Properties
    typealias Models = TagPlayListModels
    weak var viewController: TagPlayListDisplayLogic?

    // MARK: - Methods

    func presentPlayList(response: TagPlayListModels.FetchPosts.Response) {
        let displayedPosts = response.post
        viewController?.displayPlayList(viewModel: Models.FetchPosts.ViewModel(displayedPost: displayedPosts))
    }

    func presentMorePlayList(response: TagPlayListModels.FetchMorePosts.Response) {
        let displayedPosts = response.post
        viewController?.displayMorePlayList(viewModel: Models.FetchMorePosts.ViewModel(displayedPost: displayedPosts))
    }

    func presentTitleTag(response: TagPlayListModels.FetchTitleTag.Response) {
        let titleTag = response.titleTag
        viewController?.displayTitle(viewModel: Models.FetchTitleTag.ViewModel(title: titleTag))
    }
}
