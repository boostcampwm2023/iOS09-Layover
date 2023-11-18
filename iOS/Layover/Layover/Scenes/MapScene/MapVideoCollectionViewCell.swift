//
//  MapVideoCollectionViewCell.swift
//  Layover
//
//  Created by kong on 2023/11/17.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class MapVideoCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: MapVideoCollectionViewCell.self)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
