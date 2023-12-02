//
//  LOTagStackView.swift
//  Layover
//
//  Created by 황지웅 on 11/16/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit
final class LOTagStackView: UIStackView {
    lazy var tagButton1: UIButton = setButton("#밤샘")
    lazy var tagButton2: UIButton = setButton("#시차")
    lazy var tagButton3: UIButton = setButton("#고양이")

    enum Style {
        case basic
        case edit
    }

    private let style: Style

    init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        setUpConstraints()
    }

    required init(coder: NSCoder) {
        self.style = .basic
        super.init(coder: coder)
        setUpConstraints()
    }

    private func setUpConstraints() {
        [tagButton1, tagButton2, tagButton3].forEach { tagButton in
            self.addArrangedSubview(tagButton)
        }
        self.alignment = .fill
        self.distribution = .fillProportionally
        self.axis = .horizontal
        self.spacing = 8
    }

    // TODO: Component 추가 시 변경
    private func setButton(_ content: String) -> UIButton {
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
            let editButton: UIButton = UIButton()

            button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 8.0, bottom: 5.0, trailing: 25)
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
        return button
    }

    @objc private func tagDeleteButtonDidTap(_ sender: UIButton) {
        guard let button = sender.superview else { return }
        button.removeFromSuperview()
        layoutIfNeeded()
    }
}
