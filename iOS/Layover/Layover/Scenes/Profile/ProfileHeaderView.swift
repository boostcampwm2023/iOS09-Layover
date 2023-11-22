//
//  ProfileHeaderView.swift
//  Layover
//
//  Created by kong on 2023/11/21.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class ProfileHeaderView: UICollectionReusableView {

    // MARK: - UI Components

    private let profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage.profile
        return imageView
    }()

    private let nicknameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "@loinsir"
        label.textColor = .layoverWhite
        label.font = .loFont(type: .subtitle)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "안녕하세요 로인서입니다"
        label.textColor = .layoverWhite
        label.font = .loFont(type: .body3)
        return label
    }()

    private let editButton: LOButton = {
        let button: LOButton = LOButton(style: .basic)
        button.setTitle("편집", for: .normal)
        return button
    }()

    // MARK: - Object Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setConstraints()
    }

    // MARK: - Methods

    private func setConstraints() {
        addSubviews(profileImageView, nicknameLabel, descriptionLabel)
        [profileImageView, nicknameLabel, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 72),
            profileImageView.heightAnchor.constraint(equalToConstant: 72),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            nicknameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 39),
            nicknameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),

            descriptionLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 18),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -21)
        ])
    }

}
