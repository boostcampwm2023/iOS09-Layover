//
//  HomeViewController.swift
//  Layover
//
//  Created by 김인환 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayVideoURLs(with viewModel: HomeModels.CarouselVideos.ViewModel)
    func routeToPlayback()
}

final class HomeViewController: BaseViewController {

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
        collectionView.alwaysBounceVertical = false
        return collectionView
    }()

    private lazy var carouselDatasource = UICollectionViewDiffableDataSource<UUID, URL>(collectionView: carouselCollectionView) { collectionView, indexPath, url in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCarouselCollectionViewCell.identifier,
                                                            for: indexPath) as? HomeCarouselCollectionViewCell else { return UICollectionViewCell() }
        cell.setVideo(url: url, loopingAt: .zero)
        cell.configure(title: "요리왕 비룡 데뷔", tags: ["#천상의맛", "#갈갈갈", "#빨리주세요"])
        cell.moveToPlaybackSceneCallback = {
            self.interactor?.moveToPlaybackScene(with: Models.MoveToPlaybackScene.Request(index: indexPath.row, videos: [
                VideoDTO(title: "찹모찌1",
                         content: "찹모찌의 뜻은 뭘 까?",
                         location: "첫번째 우주",
                         tags: ["찹"],
                         member: MemberDTO(
                            username: "찹모찌",
                            introduce: "찹모찌임당",
                            profileImageURL: URL(string: "https://i.ibb.co/qML8vdN/2023-11-25-9-08-01.png")!),
                         sdURL: URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!,
                         hdURL: URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!),
                VideoDTO(title: "찹모찌2",
                         content: "찹모찌의 뜻은 뭘 까??",
                         location: "첫번째 우주",
                         tags: ["찹", "모"],
                         member: MemberDTO(
                            username: "찹모찌",
                            introduce: "찹모찌임당",
                            profileImageURL: URL(string: "https://i.ibb.co/qML8vdN/2023-11-25-9-08-01.png")!),
                         sdURL: URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!,
                         hdURL: URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!),
                VideoDTO(title: "찹모찌3",
                         content: "찹모찌의 뜻은 뭘 까??",
                         location: "첫번째 우주",
                         tags: ["찹", "모"],
                         member: MemberDTO(
                            username: "찹모찌",
                            introduce: "찹모찌임당",
                            profileImageURL: URL(string: "https://i.ibb.co/qML8vdN/2023-11-25-9-08-01.png")!),
                         sdURL: URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!,
                         hdURL: URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!)
            ]))
        }
        cell.addLoopingViewGesture()
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
        carouselCollectionView.dataSource = carouselDatasource
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
                    if scale >= 0.9 { // 과연 계속 호출해도 괜찮을까?
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

    // MARK: - Use Case

    private func fetchCarouselVideos() {
        interactor?.fetchVideos(with: Models.CarouselVideos.Request())
    }
}

// MARK: - DisplayLogic

extension HomeViewController: HomeDisplayLogic {
    func displayVideoURLs(with viewModel: HomeModels.CarouselVideos.ViewModel) {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, URL>()
        snapshot.appendSections([UUID()])
        snapshot.appendItems(viewModel.videoURLs)
        carouselDatasource.apply(snapshot) {
            self.playVideoAtCenterCell()
        }
    }

    func routeToPlayback() {
        router?.routeToPlayback()
    }
}
