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

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.darkGrey
        return imageView
    }()

    private let spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.backgroundColor = .clear
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        return indicator
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

    func configure(image: UIImage?, status: BoardStatus) {
        thumbnailImageView.image = image

        switch status {
        case .complete:
            spinner.stopAnimating()
            thumbnailImageView.alpha = 1.0
        default:
            spinner.startAnimating()
            thumbnailImageView.alpha = 0.5
        }
    }

    private func setUI() {
        backgroundColor = .darkGrey
        layer.cornerRadius = 10
        clipsToBounds = true
    }

    private func setConstraints() {
        contentView.addSubviews(thumbnailImageView, spinner)
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

}
