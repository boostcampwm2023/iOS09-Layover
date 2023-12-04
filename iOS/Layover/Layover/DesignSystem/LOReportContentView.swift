//
//  LOReportContentView.swift
//  Layover
//
//  Created by 황지웅 on 12/4/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class LOReportContentView: UIView {
    private let radioButton: LOCircleButton = LOCircleButton(style: .add, diameter: 24)
    private let contentLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "스팸 / 홍보 도배글이에요"
        label.font = .loFont(type: .body3)
        label.textAlignment = .left
        label.textColor = .layoverWhite
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setConstraints()
    }

    func setText(_ content: String) {
        contentLabel.text = content
    }
    private func setConstraints() {
        addSubviews(radioButton, contentLabel)
        subviews.forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            radioButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            radioButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            radioButton.trailingAnchor.constraint(equalTo: contentLabel.leadingAnchor, constant: -12),
            contentLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
