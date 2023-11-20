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
    func displayFetchedVideos(viewModel: MapModels.FetchVideo.ViewModel)
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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(MapCarouselCollectionViewCell.self, forCellWithReuseIdentifier: MapCarouselCollectionViewCell.identifier)
        return collectionView
    }()

    private lazy var carouselDatasource = UICollectionViewDiffableDataSource<UUID, ViewModel.VideoDataSource>(collectionView: carouselCollectionView) { collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCarouselCollectionViewCell.identifier,
                                                            for: indexPath) as? MapCarouselCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(urlString: item.videoURLs)
        return cell
    }

    // MARK: - Properties

    typealias Models = MapModels
    typealias ViewModel = Models.FetchVideo.ViewModel

    var interactor: MapBusinessLogic?

    // MARK: - Life Cycle

    init() {
        super.init(nibName: nil, bundle: nil)
        MapConfigurator.shared.configure(self)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        MapConfigurator.shared.configure(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.checkLocationAuthorizationStatus()
        interactor?.fetchVideos()
    }

    // MARK: - UI + Layout

    override func setConstraints() {
        view.addSubviews(mapView, searchButton, currentLocationButton, uploadButton, carouselCollectionView)
        [mapView, searchButton, currentLocationButton, uploadButton, carouselCollectionView].forEach {
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

    private func createLayout() -> UICollectionViewLayout {
        let groupWidthDimension: CGFloat = 94/375
        let minumumZoomScale: CGFloat = 73/94
        let maximumZoomScale: CGFloat = 1.0
        let section: NSCollectionLayoutSection = .makeCarouselSection(groupWidthDimension: groupWidthDimension)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 200, bottom: 0, trailing: 200)
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            let containerWidth = environment.container.contentSize.width
            items.forEach { item in
                let distanceFromCenter = abs((item.center.x - offset.x) - environment.container.contentSize.width / 2.0)
                let scale = max(maximumZoomScale - (distanceFromCenter / containerWidth), minumumZoomScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
                let cell = self.carouselCollectionView.cellForItem(at: item.indexPath) as? MapCarouselCollectionViewCell
                if scale >= maximumZoomScale * 0.9 {
                    cell?.didMoveToCenter()
                } else {
                    cell?.didMoveToSide()
                }
            }
        }
        return UICollectionViewCompositionalLayout(section: section)
    }

}

extension MapViewController: MapDisplayLogic {

    func displayFetchedVideos(viewModel: ViewModel) {
        carouselCollectionView.dataSource = carouselDatasource
        var snapshot = NSDiffableDataSourceSnapshot<UUID, ViewModel.VideoDataSource>()
        snapshot.appendSections([UUID()])
        snapshot.appendItems(viewModel.videoDataSources)
        carouselDatasource.apply(snapshot)
    }

}

#Preview {
    MapViewController()
}
