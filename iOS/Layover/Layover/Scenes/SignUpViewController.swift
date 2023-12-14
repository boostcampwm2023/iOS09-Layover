//
//  SignUpViewController.swift
//  Layover
//
//  Created by kong on 2023/11/14.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol SignUpDisplayLogic: AnyObject {
    func displayNicknameValidation(response: SignUpModels.ValidateNickname.ViewModel)
    func displayNickanmeDuplication(response: SignUpModels.CheckDuplication.ViewModel)
    func navigateToMain()
}

final class SignUpViewController: BaseViewController {

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "여정 기록을 위한\n닉네임을 입력해주세요."
        label.numberOfLines = 0
        label.font = .loFont(type: .header2)
        label.textColor = .layoverWhite
        return label
    }()

    private lazy var nicknameTextfield: LOTextField = {
        let textField = LOTextField()
        textField.placeholder = "닉네임을 입력해주세요."
        textField.addTarget(self, action: #selector(setUpTextFieldState(_:)), for: .editingChanged)
        return textField
    }()

    private let nicknameAlertLabel: UILabel = {
        let label = UILabel()
        label.font = .loFont(type: .caption)
        label.textColor = .error
        return label
    }()

    private lazy var checkDuplicateNicknameButton: LOButton = {
        let button = LOButton(style: .basic)
        button.isEnabled = false
        button.setTitle("중복확인", for: .normal)
        button.addTarget(self, action: #selector(checkDuplicateNicknameButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var confirmButton: LOButton = {
        let button = LOButton(style: .basic)
        button.isEnabled = false
        button.setTitle("회원가입", for: .normal)
        button.addTarget(self, action: #selector(signUpButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()

    var interactor: SignUpBusinessLogic?
    var router: (SignUpRoutingLogic & SignUpDataPassing)?

    // MARK: - Intiailizer

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        SignUpConfigurator.shared.configure(self)
    }

    // MARK: - UI + Layout

    override func setConstraints() {
        super.setConstraints()
        view.addSubviews(titleLabel, nicknameTextfield, nicknameAlertLabel, checkDuplicateNicknameButton, confirmButton)
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            nicknameTextfield.heightAnchor.constraint(equalToConstant: 44),
            nicknameTextfield.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 17),
            nicknameTextfield.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nicknameTextfield.trailingAnchor.constraint(equalTo: checkDuplicateNicknameButton.leadingAnchor, constant: -16),

            nicknameAlertLabel.topAnchor.constraint(equalTo: nicknameTextfield.bottomAnchor, constant: 5),
            nicknameAlertLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nicknameTextfield.trailingAnchor.constraint(equalTo: nicknameTextfield.trailingAnchor),

            checkDuplicateNicknameButton.heightAnchor.constraint(equalToConstant: 44),
            checkDuplicateNicknameButton.widthAnchor.constraint(equalToConstant: 83),
            checkDuplicateNicknameButton.centerYAnchor.constraint(equalTo: nicknameTextfield.centerYAnchor),
            checkDuplicateNicknameButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    override func setUI() {
        super.setUI()
        setNavigationBackButton()
    }

    // MARK: Methods

    private func setNavigationBackButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.iconTabBack,
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(popViewController))
    }

    // MARK: - Actions

    @objc private func setUpTextFieldState(_ sender: UITextField) {
        guard let nickname = sender.text else { return }
        interactor?.validateNickname(with: SignUpModels.ValidateNickname.Request(nickname: nickname))
    }

    @objc private func checkDuplicateNicknameButtonDidTap(_ sender: UIButton) {
        guard let nickname = nicknameTextfield.text else { return }
        checkDuplicateNicknameButton.isEnabled = false
        interactor?.checkDuplication(with: SignUpModels.CheckDuplication.Request(nickname: nickname))
    }

    @objc private func popViewController() {
        router?.routeToBack()
    }

    @objc private func signUpButtonDidTap(_ sender: UIButton) {
        guard let nickname = nicknameTextfield.text else { return }
        interactor?.signUp(with: SignUpModels.SignUp.Request(nickname: nickname))
    }
}

extension SignUpViewController: SignUpDisplayLogic {

    func displayNicknameValidation(response: SignUpModels.ValidateNickname.ViewModel) {
        nicknameAlertLabel.isHidden = response.canCheckDuplication
        checkDuplicateNicknameButton.isEnabled = response.canCheckDuplication
        nicknameAlertLabel.text = response.alertDescription
        nicknameAlertLabel.textColor = .error
    }

    func displayNickanmeDuplication(response: SignUpModels.CheckDuplication.ViewModel) {
        nicknameAlertLabel.isHidden = false
        nicknameAlertLabel.text = response.alertDescription
        nicknameAlertLabel.textColor = response.canSignUp ? .correct : .error
        confirmButton.isEnabled = response.canSignUp
    }

    func navigateToMain() {
        router?.navigateToMain()
    }
}
