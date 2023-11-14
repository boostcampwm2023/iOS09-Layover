//
//  SignUpViewController.swift
//  Layover
//
//  Created by kong on 2023/11/14.
//

import UIKit

protocol SignUpDisplayLogic {
  func displayNicknameValidation(response: Bool)
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

    private let nicknameTextfield: LOTextField = {
        let textfield = LOTextField()
        textfield.placeholder = "닉네임을 입력해주세요."
        return textfield
    }()

    private let checkDuplicateNicknameButton: LOButton = {
        let button = LOButton(style: .basic)
        button.isEnabled = false
        button.setTitle("중복확인", for: .normal)
        return button
    }()

    private let confirmButton: LOButton = {
        let button = LOButton(style: .basic)
        button.isEnabled = true
        button.setTitle("회원가입", for: .normal)
        return button
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background // TODO: Base ViewController 로직으로 분리
        setUI()

    }
    // MARK: - UI + Layout

    private func setUI() {
        [titleLabel, nicknameTextfield, checkDuplicateNicknameButton, confirmButton].forEach {
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

            checkDuplicateNicknameButton.heightAnchor.constraint(equalToConstant: 44),
            checkDuplicateNicknameButton.widthAnchor.constraint(equalToConstant: 83),
            checkDuplicateNicknameButton.centerYAnchor.constraint(equalTo: nicknameTextfield.centerYAnchor),
            checkDuplicateNicknameButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Custom Method

    func displayNicknameValidation(response: Bool) {

    }

}
