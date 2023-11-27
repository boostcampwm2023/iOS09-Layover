//
//  SignUpModels.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

enum SignUpModels {

    // MARK: - Validate Nickname Use Case

    enum ValidateNickname {
        struct Request {
            var nickname: String
        }
        struct Response {
            var nicknameState: NicknameState
        }
        struct ViewModel {
            var canCheckDuplication: Bool
            var alertDescription: String?
        }
    }

    // MARK: - Check Nickname Duplication Use Case
    enum CheckDuplication {
        struct Request {
            var nickname: String
        }
        struct Response {
            var isDuplicate: Bool
        }
        struct ViewModel {
            var canSignUp: Bool
            var alertDescription: String {
                canSignUp ? "사용가능한 닉네임입니다." : "사용중인 닉네임입니다."
            }
        }
    }

    // MARK: - Sign Up Use Case

    enum SignUp {
        enum LoginType {
            case kakao
            case apple
        }

        struct Request {
            var nickname: String
        }

        struct Response {
            var isSuccess: Bool
        }

        struct ViewModel {
        }
    }

}
