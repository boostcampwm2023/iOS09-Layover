//
//  SignUpInteractor.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol SignUpBusinessLogic {
    func validateNickname(with request: SignUpModels.ValidateNickname.Request)
    func checkDuplication(with request: SignUpModels.CheckDuplication.Request)
    func signUp(with request: SignUpModels.SignUp.Request)
}

protocol SignUpDataStore: AnyObject {
    var signUpType: SignUpModels.SignUp.LoginType? { get set }
    var socialToken: String? { get set }
}

final class SignUpInteractor: SignUpBusinessLogic, SignUpDataStore {

    // MARK: - Properties

    typealias Models = SignUpModels

    var userWorker: UserWorkerProtocol?
    var signUpWorker: SignUpWorkerProtocol?
    var presenter: SignUpPresentationLogic?

    var signUpType: SignUpModels.SignUp.LoginType?
    var socialToken: String?

    // MARK: - UseCase: 닉네임 유효성 검사

    func validateNickname(with request: SignUpModels.ValidateNickname.Request) {
        guard let userWorker else { return }
        let response = userWorker.validateNickname(request.nickname)
        presenter?.presentNicknameValidation(with: SignUpModels.ValidateNickname.Response(nicknameState: response))
    }

    func checkDuplication(with request: SignUpModels.CheckDuplication.Request) {
        Task {
            let response = await userWorker?.checkNotDuplication(for: request.nickname)
            await MainActor.run {
                presenter?.presentNicknameDuplication(with: SignUpModels.CheckDuplication.Response(isValid: response ?? false))
            }
        }
    }

    // MARK: - UseCase: SignUp

    func signUp(with request: SignUpModels.SignUp.Request) {
        guard let signUpType, let socialToken else { return }

        Task {
            switch signUpType {
            case .kakao:
                if await signUpWorker?.signUp(withKakao: socialToken, username: request.nickname) == true {
                    await MainActor.run {
                        presenter?.presentSignUpSuccess()
                    }
                }
            case .apple:
                if await signUpWorker?.signUp(withApple: socialToken, username: request.nickname) == true {
                    await MainActor.run {
                        presenter?.presentSignUpSuccess()
                    }
                }
            }
        }
    }

}
