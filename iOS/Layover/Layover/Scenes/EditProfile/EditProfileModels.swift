//
//  EditProfileModels.swift
//  Layover
//
//  Created by kong on 2023/11/27.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

enum EditProfileModels {

    enum FetchProfile {
        struct Request {
        }

        struct Response {
            let nickname: String?
            let introduce: String?
            let profileImageData: Data?
        }

        struct ViewModel {
            let nickname: String?
            let introduce: String?
            let profileImageData: Data?
        }
    }

    enum ChangeProfile {
        static let introduceLengthLimit = 30

        enum IntroduceLengthState: CustomStringConvertible {
            case overLength
            case valid

            var description: String {
                switch self {
                case .overLength:
                    return "자기소개는 \(introduceLengthLimit)자 이내로 입력해주세요."
                case .valid:
                    return ""
                }
            }
        }

        enum ChangedProfileComponent {
            case nickname(String?)
            case introduce(String?)
            case profileImage(Data?)
        }

        struct Request {
            let changedProfileComponent: ChangedProfileComponent
            let validIntroduceLength: Int = introduceLengthLimit
        }

        struct Response {
            let nicknameState: NicknameState
            let nicknameAlertDescription: String?
            let introduceAlertDescription: String?
            let canCheckNicknameDuplication: Bool?
            let canEditProfile: Bool
        }

        struct ViewModel {
            let nicknameState: NicknameState
            let nicknameAlertDescription: String?
            let introduceAlertDescription: String?
            let canCheckNicknameDuplication: Bool?
            let canEditProfile: Bool
        }
    }

    enum CheckNicknameDuplication {
        struct Request {
            let nickname: String
        }
        struct Response {
            let isValid: Bool
            let canEditProfile: Bool
        }
        struct ViewModel {
            let isValidNickname: Bool
            let canEditProfile: Bool
            var alertDescription: String {
                isValidNickname ? "사용가능한 닉네임입니다." : "사용중인 닉네임입니다."
            }
        }
    }

    enum EditProfile {
        struct Request {
            let nickname: String
            let introduce: String?
            let profileImageData: Data?
            let profileImageExtension: String?
        }

        struct Response {
            let isSuccess: Bool
        }

        struct ViewModel {
            let toastMessage: String
        }
    }

}
