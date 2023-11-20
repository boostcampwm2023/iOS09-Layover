//
//  LoginViewController.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import UIKit
import AuthenticationServices

#Preview {
    LoginViewController()
}

protocol LoginDisplayLogic: AnyObject {
    func displayPerformKakaoLogin(with viewModel: LoginModels.PerformKakaoLogin.ViewModel)
    func displayPerformAppleLogin(with viewModel: LoginModels.PerformAppleLogin.ViewMdoel)
}

final class LoginViewController: BaseViewController {

    // MARK: - Properties
    private let logoImage: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage.loLogo
        return imageView
    }()

    private let logoTitleLabel: UILabel = {
        let titleLabel: UILabel = UILabel()
        titleLabel.font = .loFont(type: .logoTitle)
        titleLabel.text = "Layover"
        return titleLabel
    }()

    private let kakaoLoginButton: UIButton = {
        let button: UIButton = UIButton()
        button.setBackgroundImage(UIImage.kakaoLogin, for: .normal)

        return button
    }()

    private let appleLoginButton: UIControl = {
        let appleLogin: UIControl = ASAuthorizationAppleIDButton(type: .continue, style: .white)
        return appleLogin
    }()

    typealias Models = LoginModels

    var interactor: LoginBusinessLogic?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        LoginConfigurator.shared.configure(self)
    }

    // MARK: - UI + Layout

    override func setConstraints() {
        view.addSubviews(logoImage, logoTitleLabel, kakaoLoginButton, appleLoginButton)
        [logoImage, logoTitleLabel, kakaoLoginButton, appleLoginButton].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 280),
            logoImage.widthAnchor.constraint(equalToConstant: 81.24),
            logoImage.heightAnchor.constraint(equalToConstant: 58.12),
            logoTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoTitleLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 14.88),
            kakaoLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            kakaoLoginButton.topAnchor.constraint(equalTo: logoTitleLabel.bottomAnchor, constant: 81),
            kakaoLoginButton.widthAnchor.constraint(equalToConstant: 315),
            kakaoLoginButton.heightAnchor.constraint(equalToConstant: 48),
            appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleLoginButton.topAnchor.constraint(equalTo: kakaoLoginButton.bottomAnchor, constant: 8),
            appleLoginButton.widthAnchor.constraint(equalToConstant: 315),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

}

// MARK: - Use Case - Login

extension LoginViewController: LoginDisplayLogic {
    func displayPerformKakaoLogin(with viewModel: LoginModels.PerformKakaoLogin.ViewModel) {
        // TODO: Logic 작성
    }

    func displayPerformAppleLogin(with viewModel: LoginModels.PerformAppleLogin.ViewMdoel) {
        // TODO: Logic 작성
    }

}
