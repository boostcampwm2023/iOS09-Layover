//
//  HomeViewController.swift
//  Layover
//
//  Created by 김인환 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol HomeDisplayLogic: AnyObject {

}

final class HomeViewController: BaseViewController, HomeDisplayLogic {

    // MARK: - Properties

    typealias Models = HomeModels
    var router: (HomeRoutingLogic & HomeDataPassing)?
    var interactor: HomeBusinessLogic?

    // MARK: - UI Components

    private let uploadButton: LOCircleButton = LOCircleButton(style: .add, diameter: 52)

    private lazy var carouselCollectionView: UICollectionView = {
        let layout = createCarouselLayout(groupWidthDimension: 314/375,
                                          groupHeightDimension: 473/534,
                                          maximumZoomScale: 1,
                                          minimumZoomScale: 473/534)
        let collectionView = UICollectionView(frame: .init(), collectionViewLayout: layout)
        collectionView.register(HomeCarouselCollectionViewCell.self, forCellWithReuseIdentifier: HomeCarouselCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .always
        return collectionView
    }()

    private lazy var carouselDatasource = UICollectionViewDiffableDataSource<UUID, Int>(collectionView: carouselCollectionView) { collectionView, indexPath, _ in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCarouselCollectionViewCell.identifier,
                                                            for: indexPath) as? HomeCarouselCollectionViewCell else { return UICollectionViewCell() }
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        return cell
    }

    // MARK: - Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {

    }

    // MARK: - View Lifecycle

    // MARK: - UI

    override func setConstraints() {
        super.setConstraints()

        [carouselCollectionView, uploadButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubviews(carouselCollectionView, uploadButton)

        NSLayoutConstraint.activate([
            carouselCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 42),
            carouselCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -109),

            uploadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            uploadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    override func setUI() {
        super.setUI()
        setCarouselCollectionView()
    }

    private func setCarouselCollectionView() {
        carouselCollectionView.dataSource = carouselDatasource
        var snapshot = NSDiffableDataSourceSnapshot<UUID, Int>()
        // sample data
        snapshot.appendSections([UUID()])
        snapshot.appendItems([1, 2, 3, 4])
        carouselDatasource.apply(snapshot)
    }

    private func createCarouselLayout(groupWidthDimension: CGFloat,
                                      groupHeightDimension: CGFloat,
                                      maximumZoomScale: CGFloat,
                                      minimumZoomScale: CGFloat) -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupWidthDimension),
                                                   heightDimension: .fractionalHeight(groupHeightDimension))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 0
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)
            section.orthogonalScrollingBehavior = .groupPagingCentered

            section.visibleItemsInvalidationHandler = { items, offset, environment in
                let containerWidth = environment.container.contentSize.width

                items.forEach { item in
                    let itemCenterRelativeToOffset = item.frame.midX - offset.x // 아이템 중심점과 container offset(왼쪽)의 거리
                    let distanceFromCenter = abs(itemCenterRelativeToOffset - containerWidth / 2.0) // container 중심점과 아이템 중심점의 거리
                    let scale = max(maximumZoomScale - (distanceFromCenter / containerWidth), minimumZoomScale) // 최대 비율에서 거리에 따라 비율을 줄임, 최소 비율보다 작아지지 않도록 함
                    item.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            }
            return section
        }
        return layout
    }

    // MARK: - Use Case

    // MARK: - Use Case - Fetch From Remote DataStore

    // MARK: - Use Case - Track Analytics

    // MARK: - Use Case - Home

}

#Preview {
    HomeViewController()
}
