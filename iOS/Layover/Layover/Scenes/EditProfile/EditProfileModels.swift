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
        enum IntroduceLengthState: CustomStringConvertible {
            case overLength
            case valid

            var description: String {
                switch self {
                case .overLength:
                    return "자기소개는 30자 이내로 입력해주세요."
                case .valid:
                    return ""
                }
            }
        }

        struct Request {
            let nickname: String?
            let introduce: String?
            let profileImageData: Data?
            let validIntroduceLength: Int = 50 // default value
        }

        struct Response {
            let newNicknameState: NicknameState
            let newIntroduceState: IntroduceLengthState
            let canCheckNicknameDuplication: Bool
            let canEditProfile: Bool
        }

        struct ViewModel {
            let nicknameAlertDescription: String
            let introduceAlertDescription: String
            let canCheckNicknameDuplication: Bool
            let canEditProfile: Bool
        }
    }

    enum CheckNicknameDuplication {
        struct Request {
            let nickname: String
        }
        struct Response {
            let isValid: Bool
        }
        struct ViewModel {
            let isValidNickname: Bool
            var alertDescription: String {
                isValidNickname ? "사용가능한 닉네임입니다." : "사용중인 닉네임입니다."
            }
        }
    }

    enum EditProfile {
        struct Request {
            let nickname: String
            let introduce: String?
            let profileImageURL: URL?
        }

        struct Response {
            let nickname: String
            let introduce: String?
            let profileImageURL: URL?
        }

        struct ViewModel {

        }
    }

}
