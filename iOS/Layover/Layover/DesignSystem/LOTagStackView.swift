//
//  LOTagStackView.swift
//  Layover
//
//  Created by 황지웅 on 11/16/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit
final class LOTagStackView: UIStackView {
    lazy var tagButton1: UIButton = setButton("#테스트1")
    lazy var tagButton2: UIButton = setButton("#테스트2")
    lazy var tagButton3: UIButton = setButton("#테스트3")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraints()
    }

    required init(coder: NSCoder) {
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
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 8.0, bottom: 5.0, trailing: 8.0)
        button.layer.cornerRadius = 12
        return button
    }
}
