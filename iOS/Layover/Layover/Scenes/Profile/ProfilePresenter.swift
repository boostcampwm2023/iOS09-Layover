//
//  ProfilePresenter.swift
//  Layover
//
//  Created by kong on 2023/11/21.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol ProfilePresentationLogic {
    func present(with response: ProfileModels.FetchProfile.Response)
}

final class ProfilePresenter: ProfilePresentationLogic {

    // MARK: - Properties

    typealias Models = ProfileModels
    weak var viewController: ProfileDisplayLogic?

    func present(with response: Models.FetchProfile.Response) {
        viewController?.fetchProfile(viewModel: Models.FetchProfile.ViewModel(nickname: response.nickname,
                                                                              introduce: response.introduce,
                                                                              profileImageURL: response.profileImageURL))
    }

}
