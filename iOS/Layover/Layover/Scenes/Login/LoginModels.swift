//
//  LoginModels.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import Foundation

enum LoginModels {

    // MARK: - Use Cases

    enum PerformKakaoLogin {
        struct Request {
        }

        struct Response {
            
        }

        struct ViewModel {

        }
    }

    enum PerformAppleLogin {
        struct Request {
            let loginViewController: LoginViewController = LoginViewController()
        }

        struct Response {

        }

        struct ViewModel {

        }
    }
}
