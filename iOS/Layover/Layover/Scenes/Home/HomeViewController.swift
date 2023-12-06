//
//  HomeViewController.swift
//  Layover
//
//  Created by 김인환 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import PhotosUI
import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayPosts(with viewModel: HomeModels.FetchPosts.ViewModel)
    func displayThumbnailImage(with viewModel: HomeModels.FetchThumbnailImageData.ViewModel)
    func routeToPlayback()
    func routeToTagPlayList()
}

final class HomeViewController: BaseViewController {

    // MARK: - Properties

    typealias Models = HomeModels
    var router: (HomeRoutingLogic & HomeDataPassing)?
    var interactor: HomeBusinessLogic?

    private let videoPickerManager: VideoPickerManager = VideoPickerManager()

    // MARK: - UI Components

    private lazy var uploadButton: LOCircleButton = {
        let button = LOCircleButton(style: .add, diameter: 52)
        button.addTarget(self, action: #selector(uploadButtonDidTap), for: .touchUpInside)
        return button
    }()

    private lazy var carouselCollectionView: UICollectionView = {
        let layout = createCarouselLayout(groupWidthDimension: 314/375,
                                          groupHeightDimension: 473/534,
                                          maximumZoomScale: 1,
                                          minimumZoomScale: 473/534)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeCarouselCollectionViewCell.self, forCellWithReuseIdentifier: HomeCarouselCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.alwaysBounceVertical = false
        return collectionView
    }()

    private lazy var carouselDatasource = UICollectionViewDiffableDataSource<UUID, Models.DisplayedPost>(collectionView: carouselCollectionView) { collectionView, indexPath, post in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCarouselCollectionViewCell.identifier,
                                                            for: indexPath) as? HomeCarouselCollectionViewCell else { return UICollectionViewCell() }

        self.interactor?.fetchThumbnailImageData(with: Models.FetchThumbnailImageData.Request(imageURL: post.thumbnailImageURL,
                                                                                              indexPath: indexPath))
        cell.setVideo(url: post.videoURL, loopingAt: .zero)
        cell.configure(title: post.title, tags: post.tags)
        cell.delegate = self
        return cell
    }

    // MARK: - Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
        setDelegation()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setDelegation()
    }

    // MARK: - Setup

    private func setup() {
        HomeConfigurator.shared.configure(self)
    }

    // MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCarouselVideos()
        playVideoAtCenterCell()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseAllVisibleCellsVideo()
    }

    // MARK: - UI

    override func setConstraints() {
        super.setConstraints()

        view.addSubviews(carouselCollectionView, uploadButton)
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

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
        carouselCollectionView.dataSource = carouselDatasource
    }

    // MARK: - Methods

    private func setDelegation() {
        carouselCollectionView.delegate = self
        videoPickerManager.videoPickerDelegate = self
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
            section.interGroupSpacing = 13
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.orthogonalScrollingProperties.decelerationRate = .normal
            section.orthogonalScrollingProperties.bounce = .never

            section.visibleItemsInvalidationHandler = { items, offset, environment in
                let containerWidth = environment.container.contentSize.width

                items.forEach { item in
                    let itemCenterRelativeToOffset = item.frame.midX - offset.x // 아이템 중심점과 container offset(왼쪽)의 거리
                    let distanceFromCenter = abs(itemCenterRelativeToOffset - containerWidth / 2.0) // container 중심점과 아이템 중심점의 거리
                    let scale = max(maximumZoomScale - (distanceFromCenter / containerWidth), minimumZoomScale) // 최대 비율에서 거리에 따라 비율을 줄임, 최소 비율보다 작아지지 않도록 함
                    item.transform = CGAffineTransform(scaleX: 1.0, y: scale)
                    guard let cell = self.carouselCollectionView.cellForItem(at: item.indexPath) as? HomeCarouselCollectionViewCell else { return }
                    if scale >= 0.9 {
                        cell.playVideo()
                    } else if scale < 0.9 {
                        cell.pauseVideo()
                    }
                }
            }
            return section
        }
        return layout
    }

    private func pauseAllVisibleCellsVideo() {
        carouselCollectionView.visibleCells.forEach { cell in
            guard let cell = cell as? HomeCarouselCollectionViewCell else { return }
            cell.pauseVideo()
        }
    }

    private func playVideoAtCenterCell() {
        let centerPoint = self.view.convert(carouselCollectionView.center, to: carouselCollectionView)
        guard let index = carouselCollectionView.indexPathForItem(at: centerPoint),
              let centerCell = carouselCollectionView.cellForItem(at: index) as? HomeCarouselCollectionViewCell
        else { return }
        centerCell.playVideo()
    }

    // MARK: - Actions

    @objc private func uploadButtonDidTap() {
        present(videoPickerManager.phPickerViewController, animated: true)
    }

    @objc private func tagButtonDidTap(_ sender: UIButton) {
        guard let tag = sender.titleLabel?.text else { return }
        interactor?.showTagPlayList(with: Models.ShowTagPlayList.Request(tag: tag))
    }

    // MARK: - Use Case

    private func fetchCarouselVideos() {
        interactor?.fetchPosts(with: Models.FetchPosts.Request())
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor?.playPosts(with: Models.PlayPosts.Request(selectedIndex: indexPath.item))
    }
}

// MARK: - HomeCarouselCollectionViewDelegate

extension HomeViewController: HomeCarouselCollectionViewDelegate {
    func homeCarouselCollectionViewDidTouchedTagButton(_ cell: HomeCarouselCollectionViewCell, tag: String) {
        interactor?.showTagPlayList(with: Models.ShowTagPlayList.Request(tag: tag))
    }
}

// MARK: - VideoPickerDelegate

extension HomeViewController: VideoPickerDelegate {

    func didFinishPickingVideo(_ url: URL) {
        self.interactor?.selectVideo(with: HomeModels.SelectVideo.Request(videoURL: url))
        Task {
            await MainActor.run {
                self.router?.routeToEditVideo()
                self.videoPickerManager.phPickerViewController.dismiss(animated: true)
            }
        }
    }

}

// MARK: - DisplayLogic

extension HomeViewController: HomeDisplayLogic {
    func displayPosts(with viewModel: HomeModels.FetchPosts.ViewModel) {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, Models.DisplayedPost>()
        snapshot.appendSections([UUID()])
        snapshot.appendItems(viewModel.displayedPosts)
        carouselDatasource.apply(snapshot) {
            self.playVideoAtCenterCell()
        }
    }

    func displayThumbnailImage(with viewModel: HomeModels.FetchThumbnailImageData.ViewModel) {
        guard let cell = carouselCollectionView.cellForItem(at: viewModel.indexPath) as? HomeCarouselCollectionViewCell,
              let thumbnailImage = UIImage(data: viewModel.imageData)
        else { return }

        cell.configure(thumbnailImage: thumbnailImage)
    }

    func routeToPlayback() {
        router?.routeToPlayback()
    }

    func routeToTagPlayList() {
        router?.routeToTagPlay()
    }
}
