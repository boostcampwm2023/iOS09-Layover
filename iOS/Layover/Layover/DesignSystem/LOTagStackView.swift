//
//  LOTagStackView.swift
//  Layover
//
//  Created by 황지웅 on 11/16/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit
final class LOTagStackView: UIStackView {

    // MARK: - TagStackView Style
    enum Style {
        case basic
        case edit
    }

    // MARK: - Properties

    private let style: Style

    // MARK: - Initializer

    init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        setUI()
    }

    required init(coder: NSCoder) {
        self.style = .basic
        super.init(coder: coder)
        setUI()
    }

    // MARK: - Methods

    // TODO: Component 추가 시 변경
    func addTag(_ content: String) {
        let button: UIButton = UIButton()
        var config = UIButton.Configuration.plain()
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.loFont(type: .body2Bold)
            return outgoing
        }

        button.backgroundColor = UIColor.primaryPurple
        button.setTitleColor(UIColor.layoverWhite, for: .normal)
        button.setTitle(content, for: .normal)
        button.configuration = config
        button.layer.cornerRadius = 12

        switch style {
        case .basic:
            button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 8.0, bottom: 5.0, trailing: 8.0)
        case .edit:
            addEditButton(in: button)
            button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 8.0, bottom: 5.0, trailing: 25)
        }

        addArrangedSubview(button)
    }

    private func setUI() {
        self.alignment = .fill
        self.distribution = .fillProportionally
        self.axis = .horizontal
        self.spacing = 8
    }

    private func addEditButton(in button: UIButton) {
        let editButton: UIButton = UIButton()
        button.addSubview(editButton)
        editButton.setBackgroundImage(UIImage(resource: .close), for: .normal)
        editButton.addTarget(self, action: #selector(tagDeleteButtonDidTap), for: .touchUpInside)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -8),
            editButton.widthAnchor.constraint(equalToConstant: 12),
            editButton.heightAnchor.constraint(equalToConstant: 12),
            editButton.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
    }

    @objc private func tagDeleteButtonDidTap(_ sender: UIButton) {
        guard let button = sender.superview else { return }
        removeArrangedSubview(button)
        button.removeFromSuperview()
    }
}
