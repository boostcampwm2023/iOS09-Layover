//
//  UploadPostViewController.swift
//  Layover
//
//  Created by kong on 2023/12/01.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol UploadPostDisplayLogic: AnyObject {
    func displayTags(viewModel: UploadPostModels.FetchTags.ViewModel)
    func displayThumbnail(viewModel: UploadPostModels.FetchThumbnail.ViewModel)
    func displayCurrentAddress(viewModel: UploadPostModels.FetchCurrentAddress.ViewModel)
    func displayUploadButton(viewModel: UploadPostModels.CanUploadPost.ViewModel)
    func displayUnsupportedFormatAlert()
}

final class UploadPostViewController: BaseViewController {

    // MARK: - UI Components

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private let contentView: UIView = UIView()

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let titleImageLabel: LOImageLabel = {
        let imageLabel = LOImageLabel()
        imageLabel.setIconImage(UIImage(resource: .title))
        imageLabel.setTitle("제목")
        return imageLabel
    }()

    private lazy var titleTextField: LOTextField = {
        let textField = LOTextField()
        textField.placeholder = "제목"
        textField.addTarget(self, action: #selector(titleTextChanged), for: .editingChanged)
        return textField
    }()

    private let tagImageLabel: LOImageLabel = {
        let imageLabel = LOImageLabel()
        imageLabel.setIconImage(UIImage(resource: .tag))
        imageLabel.setTitle("태그")
        return imageLabel
    }()

    private let tagStackView: LOTagStackView = {
        let stackView = LOTagStackView(style: .edit)
        return stackView
    }()

    private lazy var addTagButton: LOCircleButton = {
        let button = LOCircleButton(style: .smallAdd, diameter: 25)
        button.addTarget(self, action: #selector(addTagButtonDidTap), for: .touchUpInside)
        return button
    }()

    private let locationImageLabel: LOImageLabel = {
        let imageLabel = LOImageLabel()
        imageLabel.setIconImage(UIImage(resource: .locationPin))
        imageLabel.setTitle("위치")
        return imageLabel
    }()

    private let currentAddressLabel: UILabel = {
        let label = UILabel()
        label.font = .loFont(type: .body2)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let contentImageLabel: LOImageLabel = {
        let imageLabel = LOImageLabel()
        imageLabel.setIconImage(UIImage(resource: .content))
        imageLabel.setTitle("내용")
        return imageLabel
    }()

    private let contentTextView: LOTextView = {
        let textView = LOTextView(minimumHeight: 44)
        textView.isScrollEnabled = false
        return textView
    }()

    private let contentCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .loFont(type: .caption)
        label.textColor = .grey500
        return label
    }()

    private lazy var uploadButton: LOButton = {
        let button = LOButton(style: .basic)
        button.setTitle("업로드", for: .normal)
        button.addTarget(self, action: #selector(uploadButtonDidTap), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    // MARK: - Properties

    typealias Models = UploadPostModels
    var router: (NSObjectProtocol & UploadPostRoutingLogic & UploadPostDataPassing)?
    var interactor: UploadPostBusinessLogic?

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
        UploadPostConfigurator.shared.configure(self)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        setDelegation()
        addTarget()
        fetchPostInfo()
    }

    override func viewWillAppear(_ animated: Bool) {
        interactor?.fetchTags()
    }

    override func setConstraints() {
        super.setConstraints()
        view.addSubviews(scrollView, uploadButton)
        scrollView.addSubview(contentView)
        [scrollView, uploadButton, contentView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: uploadButton.topAnchor, constant: -20),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            uploadButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            uploadButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            uploadButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            uploadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        setContentViewSubviewsConstraints()
    }

    private func fetchPostInfo() {
        Task {
            await interactor?.fetchCurrentAddress()
            await interactor?.fetchThumbnailImage()
        }
    }

    private func setDelegation() {
        titleTextField.delegate = self
        contentTextView.delegate = self
    }

    private func setContentViewSubviewsConstraints() {
        contentView.addSubviews(thumbnailImageView, titleImageLabel, titleTextField, tagImageLabel, tagStackView, addTagButton,
                               locationImageLabel, currentAddressLabel, contentImageLabel, contentTextView, contentCountLabel)
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 156),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 251),
            thumbnailImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            titleImageLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 22),
            titleImageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleImageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleImageLabel.heightAnchor.constraint(equalToConstant: 22),

            titleTextField.topAnchor.constraint(equalTo: titleImageLabel.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),

            tagImageLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 22),
            tagImageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tagImageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tagImageLabel.heightAnchor.constraint(equalToConstant: 22),

            tagStackView.topAnchor.constraint(equalTo: tagImageLabel.bottomAnchor, constant: 10),
            tagStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tagStackView.heightAnchor.constraint(equalToConstant: 25),

            addTagButton.centerYAnchor.constraint(equalTo: tagStackView.centerYAnchor),
            addTagButton.leadingAnchor.constraint(equalTo: tagStackView.trailingAnchor, constant: 5),

            locationImageLabel.topAnchor.constraint(equalTo: tagStackView.bottomAnchor, constant: 22),
            locationImageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            locationImageLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            locationImageLabel.heightAnchor.constraint(equalToConstant: 22),

            currentAddressLabel.centerYAnchor.constraint(equalTo: locationImageLabel.centerYAnchor),
            currentAddressLabel.leadingAnchor.constraint(equalTo: locationImageLabel.trailingAnchor, constant: 15),
            currentAddressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            contentImageLabel.topAnchor.constraint(equalTo: locationImageLabel.bottomAnchor, constant: 22),
            contentImageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentImageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentImageLabel.heightAnchor.constraint(equalToConstant: 22),

            contentTextView.topAnchor.constraint(equalTo: contentImageLabel.bottomAnchor, constant: 10),
            contentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            contentCountLabel.centerYAnchor.constraint(equalTo: contentTextView.centerYAnchor),
            contentCountLabel.trailingAnchor.constraint(equalTo: contentTextView.trailingAnchor, constant: -10)
        ])
    }

    private func addTarget() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }

    @objc private func titleTextChanged() {
        interactor?.canUploadPost(request: Models.CanUploadPost.Request(title: titleTextField.text))
    }

    @objc private func viewDidTap() {
        self.view.endEditing(true)
    }

    @objc private func addTagButtonDidTap() {
        let request = UploadPostModels.EditTags.Request(tags: tagStackView.tags)
        interactor?.editTags(with: request)
        router?.routeToNext()
    }

    @objc private func uploadButtonDidTap() {
        guard let title = titleTextField.text else { return }
        let request = Models.UploadPost.Request(title: title,
                                                content: contentTextView.text,
                                                tags: tagStackView.tags)
        interactor?.uploadPost(request: request)
        router?.routeToBack()
    }

}

extension UploadPostViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 { return true }
        }
        guard text.count < Models.titleMaxLength else { return false }
        return true
    }
}

extension UploadPostViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let originalText = textView.text else { return true }
        let newLength = originalText.count + text.count - range.length
        return newLength <= Models.contentMaxLength
    }

    func textViewDidChange(_ textView: UITextView) {
        let textCount = textView.text == nil ? 0 : textView.text.count
        contentCountLabel.text = "\(textCount)"
    }
}

extension UploadPostViewController: UploadPostDisplayLogic {

    func displayTags(viewModel: UploadPostModels.FetchTags.ViewModel) {
        tagStackView.resetTagStackView()
        viewModel.tags.forEach { tagStackView.addTag($0) }
    }

    func displayThumbnail(viewModel: UploadPostModels.FetchThumbnail.ViewModel) {
        thumbnailImageView.image = viewModel.thumbnailImage
    }

    func displayCurrentAddress(viewModel: UploadPostModels.FetchCurrentAddress.ViewModel) {
        currentAddressLabel.text = viewModel.fullAddress
    }

    func displayUploadButton(viewModel: UploadPostModels.CanUploadPost.ViewModel) {
        uploadButton.isEnabled = viewModel.canUpload
    }

    func displayUnsupportedFormatAlert() {
        router?.routeToBack()
        Toast.shared.showToast(message: "지원하지 않는 파일 형식이에요 😢")
    }

}
