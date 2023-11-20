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

    private lazy var carouselCollectionView: UICollectionView = {
        let layout: UICollectionViewLayout = .createCarouselLayout(groupWidthDimension: 94/375,
                                                                   groupHeightDimension: 1.0,
                                                                   maximumZoomScale: 1.0,
                                                                   minimumZoomScale: 73/94)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(MapCarouselCollectionViewCell.self, forCellWithReuseIdentifier: MapCarouselCollectionViewCell.identifier)
        return collectionView
    }()

    private lazy var carouselDatasource = UICollectionViewDiffableDataSource<UUID, Int>(collectionView: carouselCollectionView) { collectionView, indexPath, _ in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCarouselCollectionViewCell.identifier,
                                                            for: indexPath) as? MapCarouselCollectionViewCell else { return UICollectionViewCell() }
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
        [mapView, searchButton, currentLocationButton, uploadButton, carouselCollectionView].forEach {
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

            uploadButton.bottomAnchor.constraint(equalTo: carouselCollectionView.topAnchor, constant: -15),
            uploadButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            currentLocationButton.bottomAnchor.constraint(equalTo: uploadButton.topAnchor, constant: -10),
            currentLocationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            carouselCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -19),
            carouselCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            carouselCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            carouselCollectionView.heightAnchor.constraint(equalToConstant: 151)
        ])
    }

    private func setCarouselCollectionView() {
        carouselCollectionView.dataSource = carouselDatasource
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
