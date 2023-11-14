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

    enum NicknameState {
        case valid
        case lessThan2GreaterThan8
        case invalidCharacter

        var alertDescription: String? {
            switch self {
            case .valid:
                return nil
            case .lessThan2GreaterThan8:
                return "2자 이상 8자 이하로 입력해주세요."
            case .invalidCharacter:
                return "입력할 수 없는 문자입니다."
            }
        }
    }

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

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
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

    func displayNicknameValidation(response: Bool) {

    }

    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    private func validate(nickname: String) -> NicknameState {
        if nickname.count < 2 || nickname.count > 8 {
            return .lessThan2GreaterThan8
        } else if nickname.wholeMatch(of: /^[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣]+/) == nil {
            return .invalidCharacter
        }
        return .valid
    }

    @objc private func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }

    @objc private func setUpTextFieldState(_ sender: UITextField) {
        guard let nickname = sender.text else { return }
        let nicknameState = validate(nickname: nickname)
        switch nicknameState {
        case .valid:
            nicknameAlertLabel.isHidden = true
            checkDuplicateNicknameButton.isEnabled = true
        case .lessThan2GreaterThan8, .invalidCharacter:
            nicknameAlertLabel.isHidden = false
            checkDuplicateNicknameButton.isEnabled = false
            nicknameAlertLabel.text = nicknameState.alertDescription
        }
    }

}
