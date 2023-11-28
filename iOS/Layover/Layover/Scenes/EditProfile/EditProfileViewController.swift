//
//  EditProfileViewController.swift
//  Layover
//
//  Created by kong on 2023/11/27.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import PhotosUI
import UIKit

protocol EditProfileDisplayLogic: AnyObject {
    func displayProfile(viewModel: EditProfileModels.FetchProfile.ViewModel)
    func displayProfileInfoValidation(viewModel: EditProfileModels.ValidateProfileInfo.ViewModel)
    func displayNicknameDuplication(viewModel: EditProfileModels.CheckNicknameDuplication.ViewModel)
}

final class EditProfileViewController: BaseViewController {

    // MARK: - UI Components

    private lazy var phPickerViewController: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let phPickerViewController = PHPickerViewController(configuration: configuration)
        phPickerViewController.delegate = self
        return phPickerViewController
    }()

    private let profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage.profile
        imageView.layer.cornerRadius = 36
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var editProfileImageButton: LOCircleButton = {
        let button = LOCircleButton(style: .photo, diameter: 32)
        button.addAction(UIAction { _ in
            self.present(self.phPickerViewController, animated: true)
        }, for: .touchUpInside)
        return button
    }()

    private lazy var nicknameTextfield: LOTextField = {
        let textField = LOTextField()
        textField.placeholder = "닉네임을 입력해주세요."
        textField.addTarget(self, action: #selector(profileInfoChanged), for: .editingChanged)
        return textField
    }()

    private let nicknameAlertLabel: UILabel = {
        let label = UILabel()
        label.font = .loFont(type: .caption)
        label.textColor = .error
        return label
    }()

    private lazy var introduceTextfield: LOTextField = {
        let textField = LOTextField()
        textField.placeholder = "소개를 입력해주세요."
        textField.addTarget(self, action: #selector(profileInfoChanged), for: .editingChanged)
        return textField
    }()

    private let introduceAlertLabel: UILabel = {
        let label = UILabel()
        label.font = .loFont(type: .caption)
        label.textColor = .error
        return label
    }()

    private lazy var checkDuplicateNicknameButton: LOButton = {
        let button = LOButton(style: .basic)
        button.isEnabled = false
        button.setTitle("중복확인", for: .normal)
        button.addTarget(self, action: #selector(checkDuplicateNicknameButtonDidTap), for: .touchUpInside)
        return button
    }()

    private lazy var confirmButton: LOButton = {
        let button = LOButton(style: .basic)
        button.isEnabled = false
        button.setTitle("완료", for: .normal)
        return button
    }()

    // MARK: - Properties

    typealias Models = EditProfileModels
    var router: (NSObjectProtocol & EditProfileRoutingLogic & EditProfileDataPassing)?
    var interactor: EditProfileBusinessLogic?

    private var changedProfileImage: UIImage?
    private var nicknameIsValid: Bool = true

    // MARK: - Object Lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchProfile()
    }

    // MARK: - Methods

    override func setUI() {
        self.title = "프로필 수정"
    }

    override func setConstraints() {
        view.addSubviews(profileImageView, editProfileImageButton, nicknameTextfield, nicknameAlertLabel, introduceTextfield,
                         introduceAlertLabel, nicknameAlertLabel, checkDuplicateNicknameButton, confirmButton)
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            profileImageView.widthAnchor.constraint(equalToConstant: 72),
            profileImageView.heightAnchor.constraint(equalToConstant: 72),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            editProfileImageButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            editProfileImageButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),

            nicknameTextfield.heightAnchor.constraint(equalToConstant: 44),
            nicknameTextfield.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 32),
            nicknameTextfield.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nicknameTextfield.trailingAnchor.constraint(equalTo: checkDuplicateNicknameButton.leadingAnchor, constant: -16),

            nicknameAlertLabel.topAnchor.constraint(equalTo: nicknameTextfield.bottomAnchor, constant: 5),
            nicknameAlertLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nicknameTextfield.trailingAnchor.constraint(equalTo: nicknameTextfield.trailingAnchor),

            checkDuplicateNicknameButton.heightAnchor.constraint(equalToConstant: 44),
            checkDuplicateNicknameButton.widthAnchor.constraint(equalToConstant: 83),
            checkDuplicateNicknameButton.centerYAnchor.constraint(equalTo: nicknameTextfield.centerYAnchor),
            checkDuplicateNicknameButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            introduceTextfield.heightAnchor.constraint(equalToConstant: 44),
            introduceTextfield.topAnchor.constraint(equalTo: nicknameAlertLabel.bottomAnchor, constant: 17),
            introduceTextfield.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            introduceTextfield.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            introduceAlertLabel.topAnchor.constraint(equalTo: introduceTextfield.bottomAnchor, constant: 5),
            introduceAlertLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            introduceAlertLabel.trailingAnchor.constraint(equalTo: introduceTextfield.trailingAnchor),

            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])

    }

    private func setup() {
        EditProfileConfigurator.shared.configure(self)
    }

    @objc private func profileInfoChanged() {
        guard let nickname = nicknameTextfield.text,
              let introduce = introduceTextfield.text else { return }
        let profileImageChanged = changedProfileImage != nil
        let profileInfoRequest = EditProfileModels.ValidateProfileInfo.Request(nickname: nickname,
                                                                               introduce: introduce,
                                                                               profileImageChanged: profileImageChanged)
        interactor?.validateProfileInfo(with: profileInfoRequest)
    }

    @objc private func checkDuplicateNicknameButtonDidTap() {
        guard let nickname = nicknameTextfield.text else { return }
        checkDuplicateNicknameButton.isEnabled = false

        let request = Models.CheckNicknameDuplication.Request(nickname: nickname)
        interactor?.checkDuplication(with: request)
    }

}

extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let item = results.first?.itemProvider
        if let item = item, item.canLoadObject(ofClass: UIImage.self) {
            item.loadObject(ofClass: UIImage.self) { [weak self] (image, _) in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.profileImageView.image = image as? UIImage
                    self.changedProfileImage = image as? UIImage
                    self.profileInfoChanged()
                }
            }
        }
    }
}

extension EditProfileViewController: EditProfileDisplayLogic {

    func displayProfile(viewModel: Models.FetchProfile.ViewModel) {
        nicknameTextfield.text = viewModel.nickname

        if let introduce = viewModel.introduce {
            introduceTextfield.text = introduce
        }

        if let image = viewModel.profileImage {
            profileImageView.image = image
        } else {
            profileImageView.image = UIImage.profile
        }
    }

    func displayProfileInfoValidation(viewModel: EditProfileModels.ValidateProfileInfo.ViewModel) {
        nicknameAlertLabel.isHidden = viewModel.canCheckDuplication
        nicknameAlertLabel.text = viewModel.nicknameAlertDescription
        nicknameAlertLabel.textColor = .error

        checkDuplicateNicknameButton.isEnabled = viewModel.canCheckDuplication

        introduceAlertLabel.text = viewModel.introduceAlertDescription
        introduceAlertLabel.textColor = .error

        confirmButton.isEnabled = viewModel.canEditProfile && !viewModel.canCheckDuplication
        checkDuplicateNicknameButton.isEnabled = viewModel.canCheckDuplication
    }

    func displayNicknameDuplication(viewModel: Models.CheckNicknameDuplication.ViewModel) {
        nicknameAlertLabel.isHidden = false
        nicknameAlertLabel.text = viewModel.alertDescription
        nicknameAlertLabel.textColor = viewModel.isValidNickname ? .correct : .error
        confirmButton.isEnabled = viewModel.isValidNickname
    }

}

#Preview {
    EditProfileViewController()
}
