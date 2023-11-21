//
//  UICollectionViewLayout+.swift
//  Layover
//
//  Created by kong on 2023/11/19.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

extension NSCollectionLayoutSection {
    static func makeCarouselSection(groupWidthDimension: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupWidthDimension),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }
}
