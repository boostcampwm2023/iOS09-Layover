//
//  ProfilePresenter.swift
//  Layover
//
//  Created by kong on 2023/11/21.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol ProfilePresentationLogic {
    func presentProfile(with response: ProfileModels.FetchProfile.Response)
    func presentMorePosts(with response: ProfileModels.FetchMorePosts.Response)
    func presentPostDetail(with response: ProfileModels.ShowPostDetail.Response)
}

final class ProfilePresenter: ProfilePresentationLogic {

    // MARK: - Properties

    typealias Models = ProfileModels
    weak var viewController: ProfileDisplayLogic?

    // MARK: - Methods

    func presentProfile(with response: Models.FetchProfile.Response) {
        let viewModel = Models.FetchProfile.ViewModel(userProfile: response.userProfile,
                                                      posts: response.posts)
        viewController?.displayProfile(viewModel: viewModel)
    }

    func presentMorePosts(with response: ProfileModels.FetchMorePosts.Response) {
        let viewModel = Models.FetchMorePosts.ViewModel(posts: response.posts)
        viewController?.displayMorePosts(viewModel: viewModel)
    }

    func presentPostDetail(with response: ProfileModels.ShowPostDetail.Response) {
        viewController?.routeToPostDetail(viewModel: Models.ShowPostDetail.ViewModel())
    }

}
