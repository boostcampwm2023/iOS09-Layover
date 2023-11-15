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
}

final class SignUpPresenter: SignUpPresentationLogic {

    // MARK: - Properties

    typealias Models = SignUpModels
    weak var viewController: SignUpDisplayLogic?

    // MARK: - UseCase: 닉네임 유효성 검사

    func presentNicknameValidation(with response: SignUpModels.ValidateNickname.Response) {
        let viewModel = Models.ValidateNickname.ViewModel(canCheckDuplication: response.nicknameState == .valid,
                                                          alertDescription: response.nicknameState.alertDescription)
        viewController?.displayNicknameValidation(response: viewModel)
    }

}
