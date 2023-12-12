//
//  EditProfileViewController.swift
//  Layover
//
//  Created by kong on 2023/11/27.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit
import PhotosUI
import OSLog

protocol EditProfileDisplayLogic: AnyObject {
    func displayProfile(with viewModel: EditProfileModels.SetProfile.ViewModel)
    func displayProfileEditCompleted(with viewModel: EditProfileModels.EditProfile.ViewModel)
    func displayChangedProfileState(with viewModel: EditProfileModels.ChangeProfile.ViewModel)
    func displayNicknameDuplication(with viewModel: EditProfileModels.CheckNicknameDuplication.ViewModel)
}

final class EditProfileViewController: BaseViewController {

    // MARK: - UI Components

    private lazy var phPickerViewController: PHPickerViewController = {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
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
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var editProfileImageButton: LOCircleButton = {
        let button = LOCircleButton(style: .photo, diameter: 32)
        button.addTarget(self, action: #selector(editProfileImageButtonDidTap), for: .touchUpInside)
        return button
    }()

    private lazy var nicknameTextfield: LOTextField = {
        let textField = LOTextField()
        textField.placeholder = "닉네임을 입력해주세요."
        textField.addTarget(self, action: #selector(nicknameChanged(_:)), for: .editingChanged)
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
        textField.addTarget(self, action: #selector(introduceChanged(_:)), for: .editingChanged)
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
        button.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
        return button
    }()

    private lazy var editProfileImageController: UIAlertController = {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "기본 이미지로 변경", style: .default) { [weak self] _ in
            guard let self else { return }
            self.changedProfileImageData = nil
            self.changedProfileImageExtension = nil
            self.changeProfileImageNeeded = true
            self.profileImageView.image = UIImage.profile
            self.profileImageDataChanged()
        }
        let albumAction = UIAlertAction(title: "앨범에서 선택", style: .default) { [weak self] _ in
            guard let self else { return }
            self.present(self.phPickerViewController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        [defaultAction, albumAction, cancelAction].forEach { alertController.addAction($0) }
        return alertController
    }()

    // MARK: - Properties

    typealias Models = EditProfileModels
    var router: (EditProfileRoutingLogic & EditProfileDataPassing)?
    var interactor: EditProfileBusinessLogic?

    private var isValidNickname = true
    private var changeProfileImageNeeded = false
    private var changedProfileImageData: Data?
    private var changedProfileImageExtension: String?

    // MARK: - Object Lifecycle

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
        EditProfileConfigurator.shared.configure(self)
    }

    // MARK: - UI Layout

    override func setUI() {
        super.setUI()
        title = "프로필 수정"
        interactor?.setProfile(with: Models.SetProfile.Request())
    }

    override func setConstraints() {
        super.setConstraints()
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

    private func profileImageDataChanged() {
        interactor?.changeProfile(with: Models.ChangeProfile.Request(changedProfileComponent: .profileImage(changedProfileImageData)))
    }

    // MARK: - Actions

    @objc private func nicknameChanged(_ sender: Any?) {
        interactor?.changeProfile(with: Models.ChangeProfile.Request(changedProfileComponent: .nickname(nicknameTextfield.text)))
    }

    @objc private func introduceChanged(_ sender: Any?) {
        interactor?.changeProfile(with: Models.ChangeProfile.Request(changedProfileComponent: .introduce(introduceTextfield.text)))
    }

    @objc private func checkDuplicateNicknameButtonDidTap() {
        guard let nickname = nicknameTextfield.text else { return }
        checkDuplicateNicknameButton.isEnabled = false

        let request = Models.CheckNicknameDuplication.Request(nickname: nickname)
        interactor?.checkDuplication(with: request)
    }

    @objc private func editProfileImageButtonDidTap() {
        self.present(editProfileImageController, animated: true)
    }

    @objc private func confirmButtonDidTap() {
        guard let nickname = nicknameTextfield.text,
              let introduce = introduceTextfield.text
        else { return }

        let request = Models.EditProfile.Request(nickname: nickname,
                                                 introduce: introduce,
                                                 changeProfileImageNeeded: changeProfileImageNeeded,
                                                 profileImageData: changedProfileImageData,
                                                 profileImageExtension: changedProfileImageExtension)
        showLoading()
        interactor?.editProfile(with: request)
    }
}

extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) {
            let item = results.first?.itemProvider
            if let item = item, item.canLoadObject(ofClass: UIImage.self) {
                item.loadFileRepresentation(for: .image) { url, _, error in
                    if let error {
                        os_log(.error, log: .ui, "%@", error.localizedDescription)
                    }

                    if let url { // item.loadFileRepresentation에서 주는 url은 클로저가 끝나면 없어지는 temporary file url이므로, 복사해서 사용한다.
                        let pathExtension = url.pathExtension
                        let temporaryCopyFileName = UUID().uuidString + ".\(pathExtension)"
                        let temporaryCopyFileURL = FileManager.default.temporaryDirectory.appendingPathComponent(temporaryCopyFileName)
                        do {
                            try FileManager.default.copyItem(atPath: url.path(),
                                                         toPath: temporaryCopyFileURL.path())
                            Task {
                                await MainActor.run {
                                    self.profileImageView.image = UIImage(contentsOfFile: temporaryCopyFileURL.path())
                                    self.changedProfileImageExtension = pathExtension
                                    self.changedProfileImageData = try? Data(contentsOf: temporaryCopyFileURL)
                                    self.changeProfileImageNeeded = true
                                    self.profileImageDataChanged()
                                }
                                try FileManager.default.removeItem(at: temporaryCopyFileURL)
                            }
                        } catch {
                            os_log(.error, log: .data, "%@", error.localizedDescription)
                        }
                    }
                }.resume()
            }
            picker.deselectAssets(withIdentifiers: results.compactMap(\.assetIdentifier))
        }
    }
}

// MARK: - Display Logic

extension EditProfileViewController: EditProfileDisplayLogic {
    func displayProfile(with viewModel: Models.SetProfile.ViewModel) {
        nicknameTextfield.text = viewModel.nickname
        if let introduce = viewModel.introduce {
            introduceTextfield.text = introduce
        }

        if let imageData = viewModel.profileImageData {
            profileImageView.image = UIImage(data: imageData)
        } else {
            profileImageView.image = UIImage.profile
        }
    }

    func displayProfileEditCompleted(with viewModel: EditProfileModels.EditProfile.ViewModel) {
        Toast.shared.showToast(message: viewModel.toastMessage)
        hideLoading()
    }

    func displayChangedProfileState(with viewModel: EditProfileModels.ChangeProfile.ViewModel) {
        nicknameAlertLabel.text = viewModel.nicknameAlertDescription
        nicknameAlertLabel.isHidden = viewModel.nicknameAlertDescription == nil
        nicknameAlertLabel.textColor = viewModel.nicknameState == .valid ? .correct : .error
        introduceAlertLabel.text = viewModel.introduceAlertDescription
        introduceAlertLabel.isHidden = viewModel.introduceAlertDescription == nil
        if let canCheckNicknameDuplication = viewModel.canCheckNicknameDuplication {
            checkDuplicateNicknameButton.isEnabled = canCheckNicknameDuplication
        }
        confirmButton.isEnabled = viewModel.canEditProfile
    }

    func displayNicknameDuplication(with viewModel: Models.CheckNicknameDuplication.ViewModel) {
        nicknameAlertLabel.isHidden = false
        nicknameAlertLabel.text = viewModel.alertDescription
        nicknameAlertLabel.textColor = viewModel.isValidNickname ? .correct : .error
        confirmButton.isEnabled = viewModel.canEditProfile
        isValidNickname = viewModel.isValidNickname
    }
}
