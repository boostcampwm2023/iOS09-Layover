//
//  EditProfileModels.swift
//  Layover
//
//  Created by kong on 2023/11/27.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

enum EditProfileModels {

    enum FetchProfile {
        struct Request {

        }

        struct Reponse {
            var nickname: String?
            var introduce: String?
            var profileImage: UIImage?
        }

        struct ViewModel {
            var nickname: String?
            var introduce: String?
            var profileImage: UIImage?
        }
    }

    enum ValidateProfileInfo {
        struct Request {
            var nickname: String
            var introduce: String?
            var profileImageChanged: Bool
        }
        struct Response {
            var isValid: Bool
            var nicknameChanged: Bool
        }
        struct ViewModel {
            var nicknameAlertDescription: String?
            var introduceAlertDescription: String?
            var canCheckDuplication: Bool
            var canEditProfile: Bool
        }
    }

    enum CheckNicknameDuplication {
        struct Request {
            var nickname: String
        }
        struct Response {
            var isDuplicate: Bool
        }
        struct ViewModel {
            var isValidNickname: Bool
            var alertDescription: String {
                isValidNickname ? "사용가능한 닉네임입니다." : "사용중인 닉네임입니다."
            }
        }
    }

    enum EditProfile {
        struct Request {
            var nickname: String
            var introduce: String?
            var profileImage: UIImage?
        }

        struct Response {
            var nickname: String
            var introduce: String?
            var profileImgaeURL: URL?
        }

        struct ViewModel {

        }
    }

}
