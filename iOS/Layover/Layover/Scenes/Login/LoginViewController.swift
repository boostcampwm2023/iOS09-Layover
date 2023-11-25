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
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .kakao

        configuration.attributedTitle = AttributedString("카카오로 계속하기",
                                                         attributes: AttributeContainer([.font: UIFont.boldSystemFont(ofSize: 17),
                                                                                         .foregroundColor: UIColor.black]))
        configuration.image = UIImage.kakaoLogo.resized(to: CGSize(width: 20, height: 20))
        configuration.imagePadding = 4
        configuration.contentInsets = .init(top: 0, leading: -4, bottom: 0, trailing: 0)
        let button: UIButton = UIButton(configuration: configuration)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()

    private let appleLoginButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .white

        configuration.attributedTitle = AttributedString("Apple로 계속하기",
                                                         attributes: AttributeContainer([.font: UIFont.boldSystemFont(ofSize: 17),
                                                                                         .foregroundColor: UIColor.black]))

        configuration.image = UIImage.appleLogo.resized(to: CGSize(width: 20, height: 20))
        configuration.imagePadding = 4
        let button: UIButton = UIButton(configuration: configuration)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()

    // MARK: Properties

    typealias Models = LoginModels

    var interactor: LoginBusinessLogic?
    var router: (LoginRoutingLogic & LoginDataPassing)?

    // MARK: - Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
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
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 236),
            logoImage.widthAnchor.constraint(equalToConstant: 81.24),
            logoImage.heightAnchor.constraint(equalToConstant: 58.12),

            logoTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoTitleLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 14.88),

            kakaoLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            kakaoLoginButton.topAnchor.constraint(equalTo: logoTitleLabel.bottomAnchor, constant: 77),
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
        router?.routeToNext()
    }

    func displayPerformAppleLogin(with viewModel: LoginModels.PerformAppleLogin.ViewMdoel) {
        // TODO: Logic 작성
    }

}

fileprivate extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
