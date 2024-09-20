//
//  LOImageLabel.swift
//  Layover
//
//  Created by kong on 2023/12/01.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class LOImageLabel: UIView {

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .loFont(type: .body2Semibold)
        label.textAlignment = .left
        label.numberOfLines = 1
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

    func setIconImage(_ image: UIImage) {
        iconImageView.image = image
    }

    func setTitle(_ title: String) {
        titleLabel.text = title
    }

    private func setConstraints() {
        addSubviews(iconImageView, titleLabel)
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 22),
            iconImageView.heightAnchor.constraint(equalToConstant: 22),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
