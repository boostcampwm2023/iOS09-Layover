//
//  MapViewController.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import MapKit
import UIKit

protocol MapDisplayLogic: AnyObject {

}

final class MapViewController: BaseViewController {

    // MARK: - UI Components

    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        return mapView
    }()

    private let searchButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.loFont(type: .body3)
        configuration.attributedTitle = AttributedString("현재 위치에서 검색하기", attributes: titleContainer)
        configuration.image = UIImage(resource: .retry)
        configuration.imagePadding = 5
        configuration.cornerStyle = .capsule
        configuration.background.backgroundColor = .darkGrey
        configuration.background.strokeColor = .grey500
        configuration.background.strokeWidth = 1
        let button = UIButton(configuration: configuration)
        return button
    }()

    private let currentLocationButton: LOCircleButton = LOCircleButton(style: .locate, diameter: 52)

    private let uploadButton: LOCircleButton = LOCircleButton(style: .add, diameter: 52)

    private lazy var videoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(MapVideoCollectionViewCell.self,
                                forCellWithReuseIdentifier: MapVideoCollectionViewCell.identifier)
        return collectionView
    }()

    private lazy var carouselDatasource = UICollectionViewDiffableDataSource<UUID, Int>(collectionView: videoCollectionView) { collectionView, indexPath, _ in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapVideoCollectionViewCell.identifier,
                                                            for: indexPath) as? MapVideoCollectionViewCell else { return UICollectionViewCell() }
        cell.layer.cornerRadius = 10
        return cell
    }

    // MARK: - Properties

    var interactor: MapBusinessLogic?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        MapConfigurator.shared.configure(self)
        interactor?.checkLocationAuthorizationStatus()
        setCarouselCollectionView()
    }

    // MARK: - UI + Layout

    override func setConstraints() {
        [mapView, searchButton, currentLocationButton, uploadButton, videoCollectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 42),

            uploadButton.bottomAnchor.constraint(equalTo: videoCollectionView.topAnchor, constant: -15),
            uploadButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            currentLocationButton.bottomAnchor.constraint(equalTo: uploadButton.topAnchor, constant: -10),
            currentLocationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            videoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -19),
            videoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            videoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            videoCollectionView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(94/375),
                                               heightDimension: .absolute(151))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            let containerWidth = environment.container.contentSize.width
            items.forEach { item in
                let distanceFromCenter = abs((item.center.x - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 79/94
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / containerWidth), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func setCarouselCollectionView() {
        videoCollectionView.dataSource = carouselDatasource
        var snapshot = NSDiffableDataSourceSnapshot<UUID, Int>()
        snapshot.appendSections([UUID()])
        snapshot.appendItems([1, 2, 3, 4, 5, 6, 7, 8, 9])
        carouselDatasource.apply(snapshot)
    }

}

extension MapViewController: MapDisplayLogic {

}

#Preview {
    MapViewController()
}
