//
//  EditProfilePresenter.swift
//  Layover
//
//  Created by kong on 2023/11/27.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditProfilePresentationLogic {
    func presentProfile(with response: EditProfileModels.FetchProfile.Response)
    func presentProfileState(with response: EditProfileModels.ChangeProfile.Response)

    func presentNicknameDuplication(with response: EditProfileModels.CheckNicknameDuplication.Response)
}

final class EditProfilePresenter: EditProfilePresentationLogic {

    // MARK: - Properties

    typealias Models = EditProfileModels
    weak var viewController: EditProfileDisplayLogic?

    // MARK: - Methods

    func presentProfile(with response: Models.FetchProfile.Response) {
        let viewModel = Models.FetchProfile.ViewModel(nickname: response.nickname,
                                                      introduce: response.introduce,
                                                      profileImageData: response.profileImageData)
        viewController?.displayProfile(with: viewModel)
    }

    func presentProfileState(with response: Models.ChangeProfile.Response) {
        let viewModel = Models.ChangeProfile.ViewModel(nicknameAlertDescription: response.newNicknameState.description,
                                                       introduceAlertDescription: response.newIntroduceState.description,
                                                       canCheckNicknameDuplication: response.canCheckNicknameDuplication,
                                                       canEditProfile: response.canEditProfile)

        viewController?.displayChangedProfileState(with: viewModel)
    }

    func presentNicknameDuplication(with response: EditProfileModels.CheckNicknameDuplication.Response) {
        return
    }

}
