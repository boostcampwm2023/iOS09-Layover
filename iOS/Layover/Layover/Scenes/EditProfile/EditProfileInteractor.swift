//
//  EditProfileInteractor.swift
//  Layover
//
//  Created by kong on 2023/11/27.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import UniformTypeIdentifiers
import OSLog

protocol EditProfileBusinessLogic {
    func setProfile(with request: EditProfileModels.SetProfile.Request)
    func changeProfile(with request: EditProfileModels.ChangeProfile.Request)
    func checkDuplication(with request: EditProfileModels.CheckNicknameDuplication.Request)
    @discardableResult
    func editProfile(with request: EditProfileModels.EditProfile.Request) -> Task<Bool, Never>
}

protocol EditProfileDataStore {
    var nickname: String? { get set }
    var introduce: String? { get set }
    var profileImageData: Data? { get set }
}

final class EditProfileInteractor: EditProfileBusinessLogic, EditProfileDataStore {

    // MARK: - Properties

    typealias Models = EditProfileModels

    var userWorker: UserWorkerProtocol?
    var presenter: EditProfilePresentationLogic?

    private var didCheckedNicknameDuplicate = true
    private var nicknameState: NicknameState = .valid
    private var introduceState: Models.ChangeProfile.IntroduceLengthState = .valid

    // MARK: - Data Store

    var nickname: String?
    var introduce: String?
    var profileImageData: Data?

    // MARK: - Use Case

    func setProfile(with request: EditProfileModels.SetProfile.Request) {
        presenter?.presentProfile(with: EditProfileModels.SetProfile.Response(nickname: nickname,
                                                                                introduce: introduce,
                                                                                profileImageData: profileImageData))
    }

    func changeProfile(with request: Models.ChangeProfile.Request) {
        let response: Models.ChangeProfile.Response

        switch request.changedProfileComponent {
        case .nickname(let changedNickname):
            didCheckedNicknameDuplicate = changedNickname == nickname
            nicknameState = userWorker?.validateNickname(changedNickname ?? "") ?? .invalidCharacter

            let canCheckNicknameDuplication = changedNickname == nickname ? false : nicknameState == .valid

            response = Models.ChangeProfile.Response(nicknameState: nicknameState,
                                                     nicknameAlertDescription: nicknameState != .valid ? nicknameState.description : nil,
                                                     introduceAlertDescription: nil,
                                                     canCheckNicknameDuplication: canCheckNicknameDuplication,
                                                     canEditProfile: false)

        case .introduce(let changedIntroduce):
            introduceState = introduceLengthState(of: changedIntroduce ?? "", by: request.validIntroduceLength)
            let canEditProfile = changedIntroduce != introduce
            && introduceState == .valid
            && nicknameState == .valid
            && didCheckedNicknameDuplicate

            let introduceAlertDescription = introduce == changedIntroduce || introduceState == .valid ? nil : introduceState.description

            response = Models.ChangeProfile.Response(nicknameState: nicknameState,
                                                     nicknameAlertDescription: nil,
                                                     introduceAlertDescription: introduceAlertDescription,
                                                     canCheckNicknameDuplication: nil,
                                                     canEditProfile: canEditProfile)

        case .profileImage(_):
            let canEditProfile = didCheckedNicknameDuplicate
            && nicknameState == .valid
            && introduceState == .valid
            response = Models.ChangeProfile.Response(nicknameState: nicknameState,
                                                     nicknameAlertDescription: nil,
                                                     introduceAlertDescription: nil,
                                                     canCheckNicknameDuplication: nil,
                                                     canEditProfile: canEditProfile)
        }

        presenter?.presentProfileState(with: response)
    }

    func checkDuplication(with request: Models.CheckNicknameDuplication.Request) {
        Task {
            guard let response = await userWorker?.checkNotDuplication(for: request.nickname) else {
                os_log(.error, log: .data, "checkDuplication Server Error")
                return
            }
            didCheckedNicknameDuplicate = response
            let canEditProfile = didCheckedNicknameDuplicate && nicknameState == .valid && introduceState == .valid
            await MainActor.run {
                presenter?.presentNicknameDuplication(with: Models.CheckNicknameDuplication.Response(isValid: response, canEditProfile: canEditProfile))
            }
        }
    }

    private func profileImageEditRequest(into imageData: Data, fileExtension: String) async -> Bool {
        guard let presignedUploadURL = await userWorker?.fetchImagePresignedURL(with: fileExtension),
              let mimeType = UTType(filenameExtension: fileExtension)?.preferredMIMEType,
              await userWorker?.modifyProfileImage(data: imageData, contentType: mimeType, to: presignedUploadURL) != nil else {
            os_log(.error, log: .data, "Edit ProfileImage Error")
            await MainActor.run {
                presenter?.presentProfile(with: Models.EditProfile.Response(isSuccess: false))
            }
            profileImageData = imageData
            return false
        }

        await MainActor.run {
            presenter?.presentProfile(with: Models.EditProfile.Response(isSuccess: true))
        }
        return true
    }

    @discardableResult
    func editProfile(with request: Models.EditProfile.Request) -> Task<Bool, Never> {
        Task {
            async let isSuccessNicknameEdit = nicknameEditRequest(into: request.nickname)
            async let isSuccessIntroduceEdit = introduceEditRequest(into: request.introduce)

            guard await isSuccessNicknameEdit, await isSuccessIntroduceEdit else {
                await MainActor.run {
                    presenter?.presentProfile(with: Models.EditProfile.Response(isSuccess: false))
                }
                return false
            }

            // 이미지 변경 요청
            if request.changeProfileImageNeeded {
                if let profileImageData = request.profileImageData, let profileImageExtension = request.profileImageExtension {
                    guard await profileImageEditRequest(into: profileImageData, fileExtension: profileImageExtension) else {
                        await MainActor.run {
                            presenter?.presentProfile(with: Models.EditProfile.Response(isSuccess: false))
                        }
                        return false
                    }
                } else { // 이미지 데이터 없는 경우 이미지 삭제 시도
                    guard await userWorker?.setProfileImageDefault() == true else {
                        await MainActor.run {
                            presenter?.presentProfile(with: Models.EditProfile.Response(isSuccess: false))
                        }
                        return false
                    }
                    profileImageData = nil
                }
            }

            await MainActor.run {
                presenter?.presentProfile(with: Models.EditProfile.Response(isSuccess: true))
            }
            return true
        }
    }

    private func nicknameEditRequest(into nickname: String) async -> Bool {
        if self.nickname != nickname {
            guard await userWorker?.modifyNickname(to: nickname) != nil else {
                os_log(.error, log: .data, "Edit Profile Error")
                return false
            }
            self.nickname = nickname
        }
        return true
    }

    private func introduceEditRequest(into introduce: String?) async -> Bool {
        guard await userWorker?.modifyIntroduce(to: introduce ?? "") != nil else {
            os_log(.error, log: .data, "Edit Profile Error")
            return false
        }
        self.introduce = introduce
        return true
    }

    private func introduceLengthState(of introduce: String, by length: Int) -> Models.ChangeProfile.IntroduceLengthState {
        introduce.count <= length ? .valid : .overLength
    }
}
