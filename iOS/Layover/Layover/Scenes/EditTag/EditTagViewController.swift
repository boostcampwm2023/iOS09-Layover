//
//  EditTagViewController.swift
//  Layover
//
//  Created by kong on 2023/12/03.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditTagDisplayLogic: AnyObject {
    func displayTags(viewModel: EditTagModels.FetchTags.ViewModel)
    func displayEditedTags(viewModel: EditTagModels.EditTags.ViewModel)
    func displayAddedTag(viewModel: EditTagModels.AddTag.ViewModel)
}

final class EditTagViewController: BaseViewController {

    // MARK: - UI Components

    private lazy var closeButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage.down, for: .normal)
        button.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        return button
    }()

    private let tagTextField: LOTextField = {
        let textField: LOTextField = LOTextField()
        textField.placeholder = "태그"
        return textField
    }()

    private let tagCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .loFont(type: .caption)
        label.textColor = .grey400
        return label
    }()

    private let tagStackView: LOTagStackView = {
        let stackView: LOTagStackView = LOTagStackView(style: .edit)
        return stackView
    }()

    // MARK: - Properties

    typealias Models = EditTagModels
    var router: (NSObjectProtocol & EditTagRoutingLogic & EditTagDataPassing)?
    var interactor: EditTagBusinessLogic?

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
        EditTagConfigurator.shared.configure(self)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchTags()
        setDelegation()
    }

    override func setConstraints() {
        super.setConstraints()
        view.addSubviews(closeButton, tagTextField, tagCountLabel, tagStackView)
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 21),

            tagTextField.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 8),
            tagTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tagTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tagTextField.heightAnchor.constraint(equalToConstant: 44),

            tagCountLabel.centerYAnchor.constraint(equalTo: tagTextField.centerYAnchor),
            tagCountLabel.trailingAnchor.constraint(equalTo: tagTextField.trailingAnchor, constant: -10),

            tagStackView.topAnchor.constraint(equalTo: tagTextField.bottomAnchor, constant: 14),
            tagStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tagStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    // MARK: - Methods

    private func setDelegation() {
        tagTextField.delegate = self
        tagStackView.delegate = self
    }

    @objc private func closeButtonDidTap() {
        router?.routeToBack()
    }

}

// MARK: - UITextFieldDelegate

extension EditTagViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let tagText = textField.text else { return true }
        textField.text = nil
        let request = Models.AddTag.Request(tags: tagStackView.tags, newTag: tagText)
        interactor?.addTag(request: request)
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 { return true }
        }
        guard text.count < Models.maxTagLength else { return false }
        return true
    }
}

extension EditTagViewController: LOTagStackViewDelegate {

    func tagStackViewDidDeletedTag(_ stackView: LOTagStackView, sender: UIButton) {
        let request = EditTagModels.EditTags.Request(editedTags: stackView.tags)
        interactor?.editTags(request: request)
    }

}

extension EditTagViewController: EditTagDisplayLogic {

    func displayTags(viewModel: EditTagModels.FetchTags.ViewModel) {
        tagStackView.resetTagStackView()
        viewModel.tags.forEach { tagStackView.addTag($0) }
        tagCountLabel.text = viewModel.tagCountDescription
    }

    func displayEditedTags(viewModel: EditTagModels.EditTags.ViewModel) {
        tagCountLabel.text = viewModel.tagCountDescription
    }

    func displayAddedTag(viewModel: EditTagModels.AddTag.ViewModel) {
        if let tag = viewModel.addedTag {
            tagStackView.addTag(tag)
        }
        tagCountLabel.text = viewModel.tagCountDescription
    }

}
