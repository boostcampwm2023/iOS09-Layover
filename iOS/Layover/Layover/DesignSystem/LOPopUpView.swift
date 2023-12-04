//
//  LOPopUpView.swift
//  Layover
//
//  Created by 황지웅 on 12/4/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class LOPopUpView: UIView {
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "콘텐츠 신고"
        label.font = .loFont(type: .subtitle)
        return label
    }()

    private let reportStackView: LOReportStackView = LOReportStackView()

    private let cancelButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.grey200, for: .normal)
        return button
    }()

    private let reportButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("신고", for: .normal)
        button.setTitleColor(.error, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setConstraints()
    }

    private func setConstraints() {
        addSubviews(titleLabel, reportStackView, cancelButton, reportButton)
        subviews.forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            titleLabel.bottomAnchor.constraint(equalTo: reportStackView.topAnchor, constant: -5),
            reportStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            reportStackView.heightAnchor.constraint(equalToConstant: 336),
            reportStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            reportStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.5),
            cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: reportButton.leadingAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 175),
            cancelButton.heightAnchor.constraint(equalToConstant: 56),
            cancelButton.topAnchor.constraint(equalTo: reportStackView.bottomAnchor),
            reportButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor),
            reportButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            reportButton.widthAnchor.constraint(equalToConstant: 175),
            reportButton.heightAnchor.constraint(equalToConstant: 56),
            reportButton.topAnchor.constraint(equalTo: reportStackView.bottomAnchor)
        ])

    }
}
