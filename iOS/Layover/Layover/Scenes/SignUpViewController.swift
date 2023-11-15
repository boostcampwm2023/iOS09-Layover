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
    func displayNickanmeDuplication()
}

final class SignUpViewController: UIViewController, SignUpDisplayLogic {

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "여정 기록을 위한\n닉네임을 입력해주세요."
        label.numberOfLines = 0
        label.font = .loFont(type: .header2)
        label.textColor = .white
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

    private let checkDuplicateNicknameButton: LOButton = {
        let button = LOButton(style: .basic)
        button.isEnabled = false
        button.setTitle("중복확인", for: .normal)
        return button
    }()

    private let confirmButton: LOButton = {
        let button = LOButton(style: .basic)
        button.isEnabled = false
        button.setTitle("회원가입", for: .normal)
        return button
    }()

    var interactor: SignUpBusinessLogic?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        SignUpConfigurator.sharedInstance.configure(self)
        setUI()

        // TODO: Base ViewController 로직으로 분리
        view.backgroundColor = .background
        addTapGesture()
    }

    // MARK: - UI + Layout

    private func setUI() {
        [titleLabel, nicknameTextfield, nicknameAlertLabel, checkDuplicateNicknameButton, confirmButton].forEach {
            view.addSubview($0)
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

    // MARK: - Custom Method

    func displayNicknameValidation(response: SignUpModels.ValidateNickname.ViewModel) {
        nicknameAlertLabel.isHidden = response.canCheckDuplication
        checkDuplicateNicknameButton.isEnabled = response.canCheckDuplication
        nicknameAlertLabel.text = response.alertDescription
    }

    func displayNickanmeDuplication() {

    }

    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func setUpTextFieldState(_ sender: UITextField) {
        guard let nickname = sender.text else { return }
        interactor?.validateNickname(with: SignUpModels.ValidateNickname.Request(nickname: nickname))
    }

    @objc private func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }

}
