//
//  ThumbnailCollectionViewCell.swift
//  Layover
//
//  Created by kong on 2023/11/21.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class ThumbnailCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Components

    private let thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: - Object Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
        setConstraints()
    }

    // MARK: - Methods

    func configure(url: URL) {
        thumnailImageView.image = UIImage.loLogo
    }

    private func setUI() {
        backgroundColor = .primaryPurple
        layer.cornerRadius = 10
        clipsToBounds = true
    }

    private func setConstraints() {
        contentView.addSubview(thumnailImageView)
        thumnailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}
