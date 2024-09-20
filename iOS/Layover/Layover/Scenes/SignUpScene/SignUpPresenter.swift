//
//  SignUpPresenter.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol SignUpPresentationLogic {
    func presentNicknameValidation(with response: SignUpModels.ValidateNickname.Response)
    func presentNicknameDuplication(with response: SignUpModels.CheckDuplication.Response)
    func presentSignUpSuccess()
}

final class SignUpPresenter: SignUpPresentationLogic {

    // MARK: - Properties

    typealias Models = SignUpModels
    weak var viewController: SignUpDisplayLogic?

    // MARK: - UseCase: 닉네임 유효성 검사

    func presentNicknameValidation(with response: Models.ValidateNickname.Response) {
        let viewModel = Models.ValidateNickname.ViewModel(canCheckDuplication: response.nicknameState == .valid,
                                                          alertDescription: response.nicknameState.description)
        viewController?.displayNicknameValidation(response: viewModel)
    }

    func presentNicknameDuplication(with response: SignUpModels.CheckDuplication.Response) {
        let viewModel = Models.CheckDuplication.ViewModel(canSignUp: response.isValid)
        viewController?.displayNicknameDuplication(response: viewModel)
    }

    func presentSignUpSuccess() {
        viewController?.navigateToMain()
    }

}
