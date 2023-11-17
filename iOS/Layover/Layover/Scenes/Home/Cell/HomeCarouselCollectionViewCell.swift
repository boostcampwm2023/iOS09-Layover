//
//  HomeCarouselCollectionViewCell.swift
//  Layover
//
//  Created by 김인환 on 11/16/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class HomeCarouselCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    // MARK: - UI Components

    // MARK: - Object lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        setConstraints()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .white
    }

    private func setConstraints() {

    }

    // MARK: - Methods
}
