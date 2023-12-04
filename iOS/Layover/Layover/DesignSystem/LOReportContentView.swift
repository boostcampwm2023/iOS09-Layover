//
//  LOReportContentView.swift
//  Layover
//
//  Created by 황지웅 on 12/4/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class LOReportContentView: UIView {

    // MARK: - UI Components

    private let whiteCircle: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .layoverWhite
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()

    private let radioButton: UIButton = {
        let button: UIButton = UIButton()
        button.layer.borderColor = UIColor.grey100.cgColor
        button.layer.borderWidth = 0.1
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = .primaryPurple
        return button
    }()

    private let contentLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "스팸 / 홍보 도배글이에요"
        label.font = .loFont(type: .body2)
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

    // MARK: - UI Methods

    private func setConstraints() {
        radioButton.addSubview(whiteCircle)
        whiteCircle.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(radioButton, contentLabel)
        subviews.forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            whiteCircle.centerXAnchor.constraint(equalTo: radioButton.centerXAnchor),
            whiteCircle.centerYAnchor.constraint(equalTo: radioButton.centerYAnchor),
            whiteCircle.widthAnchor.constraint(equalToConstant: 8),
            whiteCircle.heightAnchor.constraint(equalToConstant: 8),
            radioButton.widthAnchor.constraint(equalToConstant: 20),
            radioButton.heightAnchor.constraint(equalToConstant: 20),
            radioButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            radioButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            radioButton.trailingAnchor.constraint(equalTo: contentLabel.leadingAnchor, constant: -12),
            contentLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
