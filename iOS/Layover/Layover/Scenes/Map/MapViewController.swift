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
    func routeToPlayback()
}

final class MapViewController: BaseViewController {

    // MARK: - UI Components

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.register(LOAnnotationView.self, forAnnotationViewWithReuseIdentifier: LOAnnotationView.identifier)
        mapView.delegate = self
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

    private lazy var currentLocationButton: LOCircleButton = {
        let button = LOCircleButton(style: .locate, diameter: 52)
        button.addTarget(self, action: #selector(currentLocationButtonDidTap), for: .touchUpInside)
        return button
    }()

    private let uploadButton: LOCircleButton = LOCircleButton(style: .add, diameter: 52)

    private lazy var carouselCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = false
        collectionView.register(MapCarouselCollectionViewCell.self, forCellWithReuseIdentifier: MapCarouselCollectionViewCell.identifier)
        return collectionView
    }()

    private lazy var carouselDatasource = UICollectionViewDiffableDataSource<UUID, ViewModel.VideoDataSource>(collectionView: carouselCollectionView) { collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCarouselCollectionViewCell.identifier,
                                                            for: indexPath) as? MapCarouselCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(url: item.videoURL)
        cell.moveToPlaybackSceneCallback = {
            self.interactor?.moveToPlaybackScene(
                with: Models.MoveToPlaybackScene.Request(
                    index: indexPath.row,
                    videos: [
                        Post(
                            member: Member(
                                identifier: 1,
                                username: "찹모찌",
                                introduce: "찹모찌데스",
                                profileImageURL: URL(string: "https://i.ibb.co/qML8vdN/2023-11-25-9-08-01.png")!),
                            board: Board(
                                identifier: 1,
                                title: "찹찹찹",
                                description: "찹모찌의 뜻은 뭘까?",
                                thumbnailImageURL: nil,
                                videoURL: URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!,
                                latitude: nil,
                                longitude: nil),
                            tag: ["찹", "모", "찌"]
                            ),
                        Post(
                            member: Member(
                                identifier: 2,
                                username: "로인설",
                                introduce: "로인설데스",
                                profileImageURL: URL(string: "https://i.ibb.co/qML8vdN/2023-11-25-9-08-01.png")!),
                            board: Board(
                                identifier: 2,
                                title: "설설설",
                                description: "로인설의 뜻은 뭘까?",
                                thumbnailImageURL: nil,
                                videoURL: URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!,
                                latitude: nil,
                                longitude: nil),
                            tag: ["로", "인", "설"]
                            ),
                        Post(
                            member: Member(
                                identifier: 3,
                                username: "콩콩콩",
                                introduce: "콩콩콩데스",
                                profileImageURL: URL(string: "https://i.ibb.co/qML8vdN/2023-11-25-9-08-01.png")!),
                            board: Board(
                                identifier: 1,
                                title: "콩콩콩",
                                description: "콩콩콩의 뜻은 뭘까?",
                                thumbnailImageURL: nil,
                                videoURL: URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!,
                                latitude: nil,
                                longitude: nil),
                            tag: ["콩", "콩", "콩"]
                            )
                    ]
                )
            )
        }
        cell.addLoopingViewGesture()
        return cell
    }

    // MARK: - Properties

    typealias Models = MapModels
    typealias ViewModel = Models.FetchVideo.ViewModel
    var interactor: MapBusinessLogic?
    var router: (MapRoutingLogic & MapDataPassing)?

    private lazy var carouselCollectionViewHeight: NSLayoutConstraint = carouselCollectionView.heightAnchor.constraint(equalToConstant: 0)

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
        setCollectionViewDataSource()
        createMapAnnotation()
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

            uploadButton.bottomAnchor.constraint(equalTo: carouselCollectionView.topAnchor, constant: -10),
            uploadButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            currentLocationButton.bottomAnchor.constraint(equalTo: uploadButton.topAnchor, constant: -10),
            currentLocationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            carouselCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -19),
            carouselCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            carouselCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            carouselCollectionViewHeight
        ])
    }

    private func setCollectionViewDataSource() {
        carouselCollectionView.dataSource = carouselDatasource
    }

    // MARK: - Methods

    private func createLayout() -> UICollectionViewLayout {
        let groupWidthDimension: CGFloat = 94/375
        let minumumZoomScale: CGFloat = 73/94
        let maximumZoomScale: CGFloat = 1.0
        let inset = (screenSize.width - screenSize.width * groupWidthDimension) / 2
        let section: NSCollectionLayoutSection = .makeCarouselSection(groupWidthDimension: groupWidthDimension)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: inset,
                                                        bottom: 0,
                                                        trailing: inset)
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            let containerWidth = environment.container.contentSize.width
            items.forEach { item in
                let distanceFromCenter = abs((item.center.x - offset.x) - environment.container.contentSize.width / 2.0)
                let scale = max(maximumZoomScale - (distanceFromCenter / containerWidth), minumumZoomScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
                let cell = self.carouselCollectionView.cellForItem(at: item.indexPath) as? MapCarouselCollectionViewCell
                if scale >= maximumZoomScale * 0.9 {
                    cell?.loopingPlayerView.play()
                } else {
                    cell?.loopingPlayerView.pause()
                }
            }
        }
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func createMapAnnotation() {
        let annotation = LOAnnotation(coordinate: CLLocationCoordinate2D(latitude: 36.3276544,
                                                                         longitude: 127.427232),
                                      thumbnailURL: URL(string: "https://i.ibb.co/qML8vdN/2023-11-25-9-08-01.png")!)
        mapView.addAnnotation(annotation)
    }

    private func animateAnnotationSelection(for annotationView: MKAnnotationView, isSelected: Bool) {
        carouselCollectionViewHeight.constant = isSelected ? 151 : 0
        UIView.animate(withDuration: 0.3) {
            annotationView.transform = isSelected ? CGAffineTransform(scaleX: 1.3, y: 1.3) : .identity
            self.view.layoutIfNeeded()
        }
    }

    private func deleteCarouselDatasource() {
        var snapshot: NSDiffableDataSourceSnapshot = carouselDatasource.snapshot()
        snapshot.deleteAllItems()
        carouselDatasource.apply(snapshot)
    }

    @objc private func currentLocationButtonDidTap() {
        mapView.setUserTrackingMode(.follow, animated: true)
    }

}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        var annotationView: MKAnnotationView?
        annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: LOAnnotationView.identifier,
                                                               for: annotation)
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation, !(annotation is MKUserLocation) else { return }
        mapView.setCenter(annotation.coordinate, animated: true)
        animateAnnotationSelection(for: view, isSelected: true)
        interactor?.fetchVideos()
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        animateAnnotationSelection(for: view, isSelected: false)
        deleteCarouselDatasource()
    }

}

extension MapViewController: MapDisplayLogic {

    func displayFetchedVideos(viewModel: ViewModel) {
        var snapshot: NSDiffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<UUID, ViewModel.VideoDataSource>()
        snapshot.appendSections([UUID()])
        snapshot.appendItems(viewModel.videoDataSources)
        carouselDatasource.apply(snapshot)
    }

    func routeToPlayback() {
        router?.routeToPlayback()
    }

}
