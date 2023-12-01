//
//  UploadPostViewController.swift
//  Layover
//
//  Created by kong on 2023/12/01.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol UploadPostDisplayLogic: AnyObject {

}

class UploadPostViewController: BaseViewController, UploadPostDisplayLogic {

    // MARK: - UI Components

    private let thumnailImageView: UIImageView = {
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

    private let titleTextField: LOTextField = {
        let textField = LOTextField()
        textField.placeholder = "제목"
        return textField
    }()

    private let tagImageLabel: LOImageLabel = {
        let imageLabel = LOImageLabel()
        imageLabel.setIconImage(UIImage(resource: .tag))
        imageLabel.setTitle("태그")
        return imageLabel
    }()

    private let tagStackView: LOTagStackView = {
        let stackView = LOTagStackView()
        return stackView
    }()

    private let addTagButton: LOCircleButton = {
        let button = LOCircleButton(style: .add, diameter: 25)
        return button
    }()

    private let locationImageLabel: LOImageLabel = {
        let imageLabel = LOImageLabel()
        imageLabel.setIconImage(UIImage(resource: .locationPin))
        imageLabel.setTitle("위치")
        return imageLabel
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .loFont(type: .body2)
        label.text = "대구시 달서구 유천동"
        return label
    }()

    private let contentImageLabel: LOImageLabel = {
        let imageLabel = LOImageLabel()
        imageLabel.setIconImage(UIImage(resource: .content))
        imageLabel.setTitle("내용")
        return imageLabel
    }()

    private let contentTextView: UITextView = {
        let textView = UITextView()
        return textView
    }()

    private let uploadButton: LOButton = {
        let button = LOButton(style: .basic)
        button.setTitle("업로드", for: .normal)
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
        let viewController = self
        let interactor = UploadPostInteractor()
        let presenter = UploadPostPresenter()
        let router = UploadPostRouter()

        viewController.router = router
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
    }

    override func setConstraints() {
        super.setConstraints()
        view.addSubviews(thumnailImageView, titleImageLabel, titleTextField, tagImageLabel, tagStackView, addTagButton,
                         locationImageLabel, locationLabel, contentImageLabel, contentTextView, uploadButton)
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            thumnailImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            thumnailImageView.widthAnchor.constraint(equalToConstant: 156),
            thumnailImageView.heightAnchor.constraint(equalToConstant: 251),
            thumnailImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            titleImageLabel.topAnchor.constraint(equalTo: thumnailImageView.bottomAnchor, constant: 22),
            titleImageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleImageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleImageLabel.heightAnchor.constraint(equalToConstant: 22),

            titleTextField.topAnchor.constraint(equalTo: titleImageLabel.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),

            tagImageLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 22),
            tagImageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tagImageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tagImageLabel.heightAnchor.constraint(equalToConstant: 22),

            tagStackView.topAnchor.constraint(equalTo: tagImageLabel.bottomAnchor, constant: 10),
            tagStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tagStackView.heightAnchor.constraint(equalToConstant: 25),

            addTagButton.centerYAnchor.constraint(equalTo: tagStackView.centerYAnchor),
            addTagButton.leadingAnchor.constraint(equalTo: tagStackView.trailingAnchor, constant: 5),

            locationImageLabel.topAnchor.constraint(equalTo: tagStackView.bottomAnchor, constant: 22),
            locationImageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            locationImageLabel.trailingAnchor.constraint(equalTo: locationLabel.leadingAnchor, constant: -16),
            locationImageLabel.heightAnchor.constraint(equalToConstant: 22),

            locationLabel.centerYAnchor.constraint(equalTo: locationImageLabel.centerYAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageLabel.trailingAnchor),

            contentImageLabel.topAnchor.constraint(equalTo: locationImageLabel.bottomAnchor, constant: 22),
            contentImageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentImageLabel.trailingAnchor.constraint(equalTo: locationLabel.leadingAnchor, constant: -16),
            contentImageLabel.heightAnchor.constraint(equalToConstant: 22),

            contentTextView.topAnchor.constraint(equalTo: contentImageLabel.bottomAnchor, constant: 10),
            contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            uploadButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            uploadButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            uploadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            uploadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

}

#Preview {
    UploadPostViewController()
}
