//
//  UICollectionViewLayout+.swift
//  Layover
//
//  Created by kong on 2023/11/19.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

extension UICollectionViewLayout {
    static func createCarouselLayout(groupWidthDimension: CGFloat,
                                     groupHeightDimension: CGFloat,
                                     maximumZoomScale: CGFloat,
                                     minimumZoomScale: CGFloat) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupWidthDimension),
                                               heightDimension: .fractionalHeight(groupHeightDimension))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.visibleItemsInvalidationHandler = { items, offset, environment in
            let containerWidth = environment.container.contentSize.width
            items.forEach { item in
                let distanceFromCenter = abs((item.center.x - offset.x) - environment.container.contentSize.width / 2.0)
                let scale = max(maximumZoomScale - (distanceFromCenter / containerWidth), minimumZoomScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        return UICollectionViewCompositionalLayout(section: section)
    }
}
