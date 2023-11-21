//
//  LoginWorker.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import UIKit
import AuthenticationServices

final class AppleLoginWorker: NSObject {

    // MARK: - Properties

    typealias Models = LoginModels
    private let provider: ProviderType = Provider()
    private let window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Login Methods

    func appleLogin() {
        let appleIDProvider: ASAuthorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
        let appleLoginRequest: ASAuthorizationAppleIDRequest = appleIDProvider.createRequest()
        appleLoginRequest.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [appleLoginRequest])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension AppleLoginWorker: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//            let userIdentifier: String = appleIDCredential.user
//            let fullName: PersonNameComponents? = appleIDCredential.fullName
//            let email: String? = appleIDCredential.email
            guard let identityToken: Data = appleIDCredential.identityToken else {
                return
            }
            guard let identityTokenString: String = String(data: identityToken, encoding: .utf8) else {
                return
            }
            print(identityTokenString)
            let loginRequestDTO: LoginRequestDTO = LoginRequestDTO(accessToken: identityTokenString)
            let endPoint: EndPoint = EndPoint<LoginResponseDTO>(baseURL: "https://layoverapi.shop:3000", path: "/oauth/apple", method: .POST, bodyParameters: loginRequestDTO)
            Task {
                do {
                    let data: LoginResponseDTO = try await provider.request(with: endPoint, authenticationIfNeeded: false, retryCount: 0)
                    print(data)
                } catch {
                    print(error.localizedDescription)
                }
            }

        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error")
    }
}

extension AppleLoginWorker: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return window
    }
}
