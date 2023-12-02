//
//  EditTagViewController.swift
//  Layover
//
//  Created by kong on 2023/12/03.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditTagDisplayLogic: AnyObject {

}

final class EditTagViewController: BaseViewController, EditTagDisplayLogic {

    // MARK: - UI Components

    private let tagTextField: LOTextField = {
        let textField: LOTextField = LOTextField()
        textField.placeholder = "태그"
        return textField
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
        tagTextField.delegate = self
    }

    override func setConstraints() {
        super.setConstraints()
        view.addSubviews(tagTextField, tagStackView)
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            tagTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tagTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tagTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tagTextField.heightAnchor.constraint(equalToConstant: 44),

            tagStackView.topAnchor.constraint(equalTo: tagTextField.bottomAnchor, constant: 14),
            tagStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tagStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

}

extension EditTagViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let tagText = textField.text else { return true }
        let tag = tagStackView.addTags(tagText)
        textField.text = nil
        return true
    }
}
