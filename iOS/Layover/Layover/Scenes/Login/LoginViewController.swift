//
//  LoginViewController.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import UIKit
import AuthenticationServices

protocol LoginDisplayLogic: AnyObject {
    func displayPerformKakaoLogin(with viewModel: LoginModels.PerformKakaoLogin.ViewModel)
    func displayPerformAppleLogin(with viewModel: LoginModels.PerformAppleLogin.ViewModel)
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

    private let kakaoTitleView: UIView = UIView()

    private let kakaoLogo: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage.kakaoLogo
        return imageView
    }()

    private let kakaoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "카카오로 계속하기"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()

    private let kakaoLoginButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .kakao
        button.layer.cornerRadius = 10
        return button
    }()

    private let appleTitleView: UIView = {
        let view: UIView = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()

    private let appleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Apple로 계속하기"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()

    private let appleLogo: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage.appleLogo
        return imageView
    }()

    private let appleLoginButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        return button
    }()

    typealias Models = LoginModels

    var interactor: LoginBusinessLogic?

    // MARK: - Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonDidTapp), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
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
        setLoginButtonConstraints()
    }

    private func setLoginButtonConstraints() {
        [kakaoTitleView, kakaoLogo, kakaoLabel, appleTitleView, appleLogo, appleLabel].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        kakaoTitleView.addSubviews(kakaoLogo, kakaoLabel)
        kakaoLoginButton.addSubview(kakaoTitleView)
        appleTitleView.addSubviews(appleLogo, appleLabel)
        appleLoginButton.addSubview(appleTitleView)

        NSLayoutConstraint.activate([
            kakaoTitleView.widthAnchor.constraint(equalToConstant: 129),
            kakaoTitleView.heightAnchor.constraint(equalToConstant: 20),
            kakaoTitleView.centerXAnchor.constraint(equalTo: kakaoLoginButton.centerXAnchor),
            kakaoTitleView.centerYAnchor.constraint(equalTo: kakaoLoginButton.centerYAnchor),
            kakaoLogo.widthAnchor.constraint(equalToConstant: 20),
            kakaoLogo.heightAnchor.constraint(equalToConstant: 20),
            kakaoLogo.leadingAnchor.constraint(equalTo: kakaoTitleView.leadingAnchor),
            kakaoLogo.topAnchor.constraint(equalTo: kakaoTitleView.topAnchor),
            kakaoLogo.bottomAnchor.constraint(equalTo: kakaoTitleView.bottomAnchor),
            kakaoLabel.topAnchor.constraint(equalTo: kakaoTitleView.topAnchor),
            kakaoLabel.bottomAnchor.constraint(equalTo: kakaoTitleView.bottomAnchor),
            kakaoLabel.leadingAnchor.constraint(equalTo: kakaoLogo.trailingAnchor, constant: 1.5),

            appleTitleView.widthAnchor.constraint(equalToConstant: 129),
            appleTitleView.heightAnchor.constraint(equalToConstant: 20),
            appleTitleView.centerXAnchor.constraint(equalTo: appleLoginButton.centerXAnchor),
            appleTitleView.centerYAnchor.constraint(equalTo: appleLoginButton.centerYAnchor),
            appleLogo.widthAnchor.constraint(equalToConstant: 20),
            appleLogo.heightAnchor.constraint(equalToConstant: 20),
            appleLogo.leadingAnchor.constraint(equalTo: appleTitleView.leadingAnchor),
            appleLogo.topAnchor.constraint(equalTo: appleTitleView.topAnchor),
            appleLogo.bottomAnchor.constraint(equalTo: appleTitleView.bottomAnchor),
            appleLabel.topAnchor.constraint(equalTo: appleTitleView.topAnchor),
            appleLabel.bottomAnchor.constraint(equalTo: appleTitleView.bottomAnchor),
            appleLabel.leadingAnchor.constraint(equalTo: appleLogo.trailingAnchor, constant: 1.5)
        ])
    }

    @objc func appleLoginButtonDidTapp() {
        guard let window: UIWindow = self.view.window else {
            return
        }
        let request: LoginViewController.Models.PerformAppleLogin.Request  = Models.PerformAppleLogin.Request(window: window)
        interactor?.performAppleLogin(with: request)
    }
}

// MARK: - Use Case - Login

extension LoginViewController: LoginDisplayLogic {
    func displayPerformKakaoLogin(with viewModel: LoginModels.PerformKakaoLogin.ViewModel) {
        // TODO: Logic 작성
    }

    func displayPerformAppleLogin(with viewModel: LoginModels.PerformAppleLogin.ViewModel) {
        // TODO: Logic 작성
    }

}
//
//#Preview {
//    LoginViewController()
//}
