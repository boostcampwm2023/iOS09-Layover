//
//  EditProfilePresenter.swift
//  Layover
//
//  Created by kong on 2023/11/27.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditProfilePresentationLogic {
    func presentProfile(with response: EditProfileModels.FetchProfile.Reponse)
    func presentProfileInfoValidation(with response: EditProfileModels.ValidateProfileInfo.Response)
    func presentNicknameDuplication(with response: EditProfileModels.CheckNicknameDuplication.Response)
}

final class EditProfilePresenter: EditProfilePresentationLogic {

    // MARK: - Properties

    typealias Models = EditProfileModels
    weak var viewController: EditProfileDisplayLogic?

    func presentProfile(with response: EditProfileModels.FetchProfile.Reponse) {
        let viewModel = Models.FetchProfile.ViewModel(nickname: response.nickname,
                                                      introduce: response.introduce,
                                                      profileImage: response.profileImage)
        viewController?.displayProfile(viewModel: viewModel)
    }

    func presentProfileInfoValidation(with response: EditProfileModels.ValidateProfileInfo.Response) {
        let viewModel = Models.ValidateProfileInfo.ViewModel(canCheckDuplication: response.nicknameChanged,
                                                             canEditProfile: response.isValid)
        viewController?.displayProfileInfoValidation(viewModel: viewModel)
    }

    func presentNicknameDuplication(with response: EditProfileModels.CheckNicknameDuplication.Response) {
        let viewModel = Models.CheckNicknameDuplication.ViewModel(isValidNickname: !response.isDuplicate)
        viewController?.displayNicknameDuplication(viewModel: viewModel)
    }

}
