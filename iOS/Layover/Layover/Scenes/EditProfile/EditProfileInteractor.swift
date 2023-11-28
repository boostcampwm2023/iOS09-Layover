//
//  EditProfileInteractor.swift
//  Layover
//
//  Created by kong on 2023/11/27.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditProfileBusinessLogic {
    func fetchProfile()
    func validateProfileInfo(with request: EditProfileModels.ValidateProfileInfo.Request)
    func checkDuplication(with request: EditProfileModels.CheckNicknameDuplication.Request)
    func editProfile(with requeset: EditProfileModels.EditProfile.Request)
}

protocol EditProfileDataStore {
    var nickname: String? { get set }
    var introduce: String? { get set }
    var profileImage: UIImage? { get set }
}

final class EditProfileInteractor: EditProfileBusinessLogic, EditProfileDataStore {

    // MARK: - Properties

    typealias Models = EditProfileModels

    var userWorker: UserWorkerProtocol?
    var presenter: EditProfilePresentationLogic?

    // MARK: - Data Store

    var nickname: String?
    var introduce: String?
    var profileImage: UIImage?

    // MARK: - Use Case

    func fetchProfile() {
        presenter?.presentProfile(with: EditProfileModels.FetchProfile.Reponse(nickname: nickname,
                                                                               introduce: introduce,
                                                                               profileImage: profileImage))
    }

    func validateProfileInfo(with request: Models.ValidateProfileInfo.Request) {
        let nicknameChanged = nickname != request.nickname
        let introduceChanged = introduce != request.introduce
        let profileInfoChanged = nicknameChanged || request.profileImageChanged || introduceChanged
        let profileInfoValiation = (userWorker?.validateNickname(request.nickname) == .valid) && validateIntroduce(request.introduce ?? "")
        let response = EditProfileModels.ValidateProfileInfo.Response(isValid: profileInfoChanged && profileInfoValiation,
                                                                      nicknameChanged: nicknameChanged)
        presenter?.presentProfileInfoValidation(with: response)
    }

    func checkDuplication(with request: Models.CheckNicknameDuplication.Request) {
        Task {
            do {
                let response = try await userWorker?.checkDuplication(for: request.nickname)
                await MainActor.run {
                    presenter?.presentNicknameDuplication(with: Models.CheckNicknameDuplication.Response(isDuplicate: response ?? true))
                }
            } catch let error {
                // TODO: present toast
                print(error.localizedDescription)
            }
        }
    }

    func editProfile(with requeset: Models.EditProfile.Request) {

    }

    private func validateIntroduce(_ introduce: String) -> Bool {
        return introduce.count <= 50
    }

}
