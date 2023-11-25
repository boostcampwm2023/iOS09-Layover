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
}

protocol SignUpDataStore { }

final class SignUpInteractor: SignUpBusinessLogic, SignUpDataStore {

    // MARK: - Properties

    typealias Models = SignUpModels

    var userWorker: UserWorkerProtocol?
    var presenter: SignUpPresentationLogic?

    // MARK: - UseCase: 닉네임 유효성 검사

    func validateNickname(with request: SignUpModels.ValidateNickname.Request) {
        let response = check(nickname: request.nickname)
        presenter?.presentNicknameValidation(with: response)
    }

    func checkDuplication(with request: SignUpModels.CheckDuplication.Request) {
        Task {
            do {
                let response = try await userWorker?.checkDuplication(for: request.nickname)
                await MainActor.run {
                    presenter?.presentNicknameDuplication(with: SignUpModels.CheckDuplication.Response(isDuplicate: response ?? true))
                }
            } catch let error {
                // TODO: present toast
                print(error.localizedDescription)
            }
        }
    }

    private func check(nickname: String) -> SignUpModels.ValidateNickname.Response {
        if nickname.count < 2 || nickname.count > 8 {
            return .init(nicknameState: .lessThan2GreaterThan8)
        } else if nickname.wholeMatch(of: /^[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣]+/) == nil {
            return .init(nicknameState: .invalidCharacter)
        }
        return .init(nicknameState: .valid)
    }

}
