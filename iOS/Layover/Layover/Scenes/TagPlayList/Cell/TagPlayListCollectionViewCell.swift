//
//  TagPlayListCollectionViewCell.swift
//  Layover
//
//  Created by 김인환 on 11/29/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class TagPlayListCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Components

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.loFont(ofSize: 15, weight: .semibold, type: .pretendard)
        label.textAlignment = .natural
        return label
    }()

    // MARK: - Properties

    private(set) var playID: Int?

    // MARK: - Initializer

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
        contentView.addSubviews(thumbnailImageView, titleLabel)
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14)
        ])
    }

    func configure(playID: Int, thumbnailImage: UIImage, title: String) {
        self.playID = playID
        thumbnailImageView.image = thumbnailImage
        titleLabel.text = title
    }

}
