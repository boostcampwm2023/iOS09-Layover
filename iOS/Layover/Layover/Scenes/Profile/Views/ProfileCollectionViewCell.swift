//
//  ProfileCollectionViewCell.swift
//  Layover
//
//  Created by kong on 2023/12/03.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class ProfileCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Components

    private let profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: UIImage.profile)
        imageView.layer.cornerRadius = 36
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let nicknameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .layoverWhite
        label.font = .loFont(type: .subtitle)
        return label
    }()

    private let introduceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .layoverWhite
        label.font = .loFont(type: .body3)
        return label
    }()

    let editButton: LOButton = {
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

    func configure(profileImageURL: URL?,
                   nickname: String?,
                   introduce: String?) {
        if let profileImageURL {
            profileImageView.lo.setImage(with: profileImageURL)
        } else {
            profileImageView.image = UIImage.profile
        }
        nicknameLabel.text = nickname
        introduceLabel.text = introduce
    }

    private func setConstraints() {
        addSubviews(profileImageView, nicknameLabel, editButton, introduceLabel)
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 72),
            profileImageView.heightAnchor.constraint(equalToConstant: 72),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            nicknameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 39),
            nicknameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nicknameLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -10),

            editButton.centerYAnchor.constraint(equalTo: nicknameLabel.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            editButton.heightAnchor.constraint(equalToConstant: 34),
            editButton.widthAnchor.constraint(equalToConstant: 58),

            introduceLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 18),
            introduceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            introduceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            introduceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -21)
        ])
    }

}
