//
//  EditProfileInteractor.swift
//  Layover
//
//  Created by kong on 2023/11/27.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import OSLog

protocol EditProfileBusinessLogic {
    func fetchProfile(with request: EditProfileModels.FetchProfile.Request)
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

    private var isChangedProfileImage = false

    // MARK: - Data Store

    var nickname: String?
    var introduce: String?
    var profileImageData: Data?

    // MARK: - Use Case

    func fetchProfile(with request: EditProfileModels.FetchProfile.Request) {
        presenter?.presentProfile(with: EditProfileModels.FetchProfile.Response(nickname: nickname,
                                                                               introduce: introduce,
                                                                               profileImageData: profileImageData))
    }

    func changeProfile(with request: Models.ChangeProfile.Request) {
        let changedNicknameState = userWorker?.validateNickname(request.nickname ?? "")
        let changedIntroduceState = introduceLengthState(of: request.introduce ?? "", by: request.validIntroduceLength)

        // 닉네임이 변경되었는지, 변경되었다면 변경된 닉네임이 유효한지
        let canCheckNicknameDuplication = nickname != request.nickname
                                        && changedNicknameState == .valid

        // 이미지, 닉네임과 자기소개 중 하나라도 변경되었고, 변경된 닉네임과 자기소개가 유효한지
        let canEditProfile = changedNicknameState == .valid && changedIntroduceState == .valid
        && (nickname != request.nickname || introduce != request.introduce || request.profileImageData != nil)


        let response = Models.ChangeProfile.Response(newNicknameState: userWorker?.validateNickname(request.nickname ?? "") ?? .valid,
                                                     newIntroduceState: introduceLengthState(of: request.introduce ?? "",
                                                                                    by: request.validIntroduceLength),
                                                     canCheckNicknameDuplication: canCheckNicknameDuplication,
                                                     canEditProfile: canEditProfile)

        presenter?.presentProfileState(with: response)
    }

    func checkDuplication(with request: Models.CheckNicknameDuplication.Request) {
        Task {
            guard let response = await userWorker?.checkNotDuplication(for: request.nickname) else {
                os_log(.error, log: .data, "checkDuplication Server Error")
                return
            }
            await MainActor.run {
                presenter?.presentNicknameDuplication(with: Models.CheckNicknameDuplication.Response(isValid: response))
            }
        }
    }

    @discardableResult
    func editProfile(with request: Models.EditProfile.Request) -> Task<Bool, Never> {
        Task {
            async let modifyNicknameResponse = userWorker?.modifyNickname(to: request.nickname)
            async let modifyIntroduceResponse = userWorker?.modifyIntroduce(to: request.introduce ?? "")

            guard await modifyNicknameResponse != nil, await modifyIntroduceResponse != nil else {
                os_log(.error, log: .data, "Edit Profile Error")
                return false
            }

            // 프로필 이미지 바꾼 경우
            guard let modifiedProfileImageURL = request.profileImageURL, modifiedProfileImageURL.isFileURL,
               let presignedUploadURL = await userWorker?.fetchImagePresignedURL(with: modifiedProfileImageURL.pathExtension),
               let modifyProfileImageResponse = await userWorker?.modifyProfileImage(from: modifiedProfileImageURL,
                                                                                     to: presignedUploadURL),
               modifyProfileImageResponse == true else {
                os_log(.error, log: .data, "Edit ProfileImage Error")
                return false
            }

//            await MainActor.run {
//                presenter?.presentProfile(with: Models.EditProfile.Response(nickname: request.nickname,
//                                                                            introduce: request.introduce ?? "",
//                                                                            profileImageURL: URL(string: presignedUploadURL)))
//            }
            return true
        }
    }

    private func introduceLengthState(of introduce: String, by length: Int) -> Models.ChangeProfile.IntroduceLengthState {
        introduce.count <= length ? .valid : .overLength
    }
}
