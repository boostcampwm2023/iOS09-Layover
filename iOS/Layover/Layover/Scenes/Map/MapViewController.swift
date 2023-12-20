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
    func displayFetchedPosts(viewModel: MapModels.FetchPosts.ViewModel)
    func displayCurrentLocation()
    func displayDefaultLocation(viewModel: MapModels.CheckLocationAuthorizationOnEntry.ViewModel)
    func routeToPlayback()
    func routeToVideoPicker()
    func openSetting()
}

final class MapViewController: BaseViewController {

    // MARK: - UI Components

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.register(LOAnnotationView.self, forAnnotationViewWithReuseIdentifier: LOAnnotationView.identifier)
        mapView.delegate = self
        return mapView
    }()

    private lazy var searchButton: UIButton = {
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
        button.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
        return button
    }()

    private lazy var currentLocationButton: LOCircleButton = {
        let button = LOCircleButton(style: .locate, diameter: 52)
        button.addTarget(self, action: #selector(currentLocationButtonDidTap), for: .touchUpInside)
        return button
    }()

    private lazy var uploadButton: LOCircleButton = {
        let button = LOCircleButton(style: .add, diameter: 52)
        button.addTarget(self, action: #selector(uploadButtonDidTap), for: .touchUpInside)
        return button
    }()

    private lazy var carouselCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = false
        collectionView.register(MapCarouselCollectionViewCell.self, forCellWithReuseIdentifier: MapCarouselCollectionViewCell.identifier)
        return collectionView
    }()

    private lazy var carouselDatasource = UICollectionViewDiffableDataSource<UUID, Models.DisplayedPost>(collectionView: carouselCollectionView) { collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCarouselCollectionViewCell.identifier,
                                                            for: indexPath) as? MapCarouselCollectionViewCell else { return UICollectionViewCell() }
        cell.setVideo(url: item.videoURL)
        cell.configure(thumbnailImageData: item.thumbnailImageData)
        return cell
    }

    // MARK: - Properties

    typealias Models = MapModels
    var interactor: MapBusinessLogic?
    var router: (MapRoutingLogic & MapDataPassing)?

    private let videoPickerManager: VideoPickerManager = VideoPickerManager()
    private lazy var carouselCollectionViewHeight: NSLayoutConstraint = carouselCollectionView.heightAnchor.constraint(equalToConstant: 0)
    private var displayedPost: [Models.DisplayedPost] = []

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
        setCollectionViewDataSource()
        setDelegation()
    }

    override func viewWillAppear(_ animated: Bool) {
        interactor?.checkLocationAuthorizationOnEntry()
        fetchPosts()
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

    private func fetchPosts() {
        Task {
            await interactor?.fetchPosts()
        }
    }

    private func setDelegation() {
        carouselCollectionView.delegate = self
        videoPickerManager.videoPickerDelegate = self
    }

    private func createLayout() -> UICollectionViewLayout {
        let groupWidthDimension: CGFloat = 94/375
        let minumumZoomScale: CGFloat = 73/94
        let maximumZoomScale: CGFloat = 1.0
        let inset = (screenSize.width - screenSize.width * groupWidthDimension) / 2
        let section: NSCollectionLayoutSection = .makeCarouselSection(groupWidthDimension: groupWidthDimension)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: inset,
                                                        bottom: 0,
                                                        trailing: inset)
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            let containerWidth = environment.container.contentSize.width
            items.forEach { [weak self] item in
                let distanceFromCenter = abs((item.center.x - offset.x) - environment.container.contentSize.width / 2.0)
                let scale = max(maximumZoomScale - (distanceFromCenter / containerWidth), minumumZoomScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
                guard let cell = self?.carouselCollectionView.cellForItem(at: item.indexPath) as? MapCarouselCollectionViewCell else { return }
                if scale >= maximumZoomScale * 0.9 {
                    self?.selectAnnotation(at: item.indexPath)
                } else {
                    cell.pause()
                }
            }
        }
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func createMapAnnotation(post: Models.DisplayedPost) {
        let annotation = LOAnnotation(coordinate: CLLocationCoordinate2D(latitude: post.latitude,
                                                                         longitude: post.longitude),
                                      boardID: post.boardID,
                                      thumbnailImageData: post.thumbnailImageData)
        mapView.addAnnotation(annotation)
    }

    private func animateAnnotationSelection(for annotationView: MKAnnotationView, isSelected: Bool) {
        carouselCollectionViewHeight.constant = isSelected ? 151 : 0
        UIView.animate(withDuration: 0.3) {
            annotationView.transform = isSelected ? CGAffineTransform(scaleX: 1.3, y: 1.3) : .identity
        }
    }

    private func selectAnnotation(at indexPath: IndexPath) {
        let focusedPost = displayedPost[indexPath.row]
        let focusedAnnotaion = mapView.annotations
            .map { $0 as? LOAnnotation }
            .compactMap { $0 }
            .filter { $0.boardID == focusedPost.boardID }
            .first
        guard let focusedAnnotaion else { return }
        mapView.selectAnnotation(focusedAnnotaion, animated: true)
    }

    @objc private func searchButtonDidTap() {
        searchButton.isHidden = true
        Task {
            await interactor?.fetchPost(latitude: mapView.centerCoordinate.latitude,
                                        longitude: mapView.centerCoordinate.longitude)
        }
    }

    @objc private func currentLocationButtonDidTap() {
        mapView.setUserTrackingMode(.follow, animated: true)
        Task {
            await interactor?.fetchPosts()
        }
    }

    @objc private func uploadButtonDidTap() {
        interactor?.checkLocationPermissionOnUpload()
    }

}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        if let annotaion = annotation as? LOAnnotation {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: LOAnnotationView.identifier,
                                                                       for: annotation) as? LOAnnotationView
            annotationView?.setThumbnailImage(data: annotaion.thumbnailImageData)
            return annotationView
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation, !(annotation is MKUserLocation) else { return }
        mapView.setCenter(annotation.coordinate, animated: true)
        animateAnnotationSelection(for: view, isSelected: true)

        if let annotaion = annotation as? LOAnnotation {
            // 선택된 pin 정보와 datasource를 비교해 selected item을 찾음
            let snapshot = carouselDatasource.snapshot()
            guard let selectedItemIdentifiers = snapshot.itemIdentifiers.filter({ post in
                return post.boardID == annotaion.boardID
            }).first else { return }
            guard let section = snapshot.sectionIdentifier(containingItem: selectedItemIdentifiers),
                  let itemIndex = snapshot.indexOfItem(selectedItemIdentifiers),
                  let sectionIndex = snapshot.indexOfSection(section) else { return }
            let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
            carouselCollectionView.scrollToItem(at: indexPath,
                                                at: .centeredHorizontally,
                                                animated: false)
            guard let cell = carouselCollectionView.cellForItem(at: indexPath) as? MapCarouselCollectionViewCell else { return }
            cell.play()
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        animateAnnotationSelection(for: view, isSelected: false)
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if mapView.userTrackingMode != .follow {
            searchButton.isHidden = false
        }
    }

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        searchButton.isHidden = true
    }

}

// MARK: - VideoPickerDelegate

extension MapViewController: VideoPickerDelegate {

    func didFinishPickingVideo(_ url: URL) {
        interactor?.selectVideo(with: Models.SelectVideo.Request(videoURL: url))
        Task {
            await MainActor.run {
                videoPickerManager.phPickerViewController.dismiss(animated: true)
                router?.routeToEditVideo()
            }
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.primaryPurple.withAlphaComponent(0.6)
            renderer.fillColor = UIColor.primaryPurple.withAlphaComponent(0.3)
            renderer.lineWidth = 2.0
            return renderer
        }
        return MKOverlayRenderer()
    }

}

// MARK: - MapDisplayLogic

extension MapViewController: MapDisplayLogic {

    func displayFetchedPosts(viewModel: MapModels.FetchPosts.ViewModel) {
        displayedPost = viewModel.displayedPosts

        var snapshot: NSDiffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<UUID, Models.DisplayedPost>()
        snapshot.appendSections([UUID()])
        snapshot.appendItems(viewModel.displayedPosts)
        carouselDatasource.apply(snapshot)

        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

        let circleOverlay = MKCircle(center: mapView.centerCoordinate, radius: Models.searchRadiusInMeters)
        mapView.addOverlay(circleOverlay, level: .aboveLabels)
        viewModel.displayedPosts.forEach { createMapAnnotation(post: $0) }
    }

    func routeToPlayback() {
        router?.routeToPlayback()
    }

    func routeToVideoPicker() {
        present(videoPickerManager.phPickerViewController, animated: true)
    }

    func openSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    func displayCurrentLocation() {
        currentLocationButton.isHidden = false
        mapView.setUserTrackingMode(.follow, animated: true)
    }

    func displayDefaultLocation(viewModel: MapModels.CheckLocationAuthorizationOnEntry.ViewModel) {
        currentLocationButton.isHidden = true
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: viewModel.latitude,
                                                                           longitude: viewModel.longitude),
                                            latitudinalMeters: 1000,
                                            longitudinalMeters: 1000)
    }

}

extension MapViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let post = carouselDatasource.itemIdentifier(for: indexPath) else { return }
        switch post.boardStatus {
        case .complete:
            interactor?.playPosts(with: Models.PlayPosts.Request(selectedIndex: indexPath.item))
        default:
            Toast.shared.showToast(message: "인코딩 중인 영상입니다. 잠시만 기다려주세요!")
        }
    }
}
