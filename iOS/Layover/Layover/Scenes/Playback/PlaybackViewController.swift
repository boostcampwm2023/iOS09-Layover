//
//  PlaybackViewController.swift
//  Layover
//
//  Created by 황지웅 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit
import AVFoundation

protocol PlaybackDisplayLogic: AnyObject {
}

final class PlaybackViewController: UIViewController, PlaybackDisplayLogic {
    // MARK: - Type
    enum ViewType {
        case home
        case map
        case profile
        case tag
    }

    enum Section {
        case main
    }

    // TODO: VIP 적용 시 Model로 빼서 presenter에서 ViewModel로 받기, 무한 스크롤 테스트 용
    struct VideoModel: Hashable {
        var id: UUID = UUID()
        let title: String
        let videoURL: URL
    }
    // MARK: - UI Components

    private let playbackCollectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()

    // MARK: - Properties

    private var dataSource: UICollectionViewDiffableDataSource<Section, VideoModel>?

    private var prevPlaybackCell: PlaybackCell?

    private var checkTelePort: Bool = false

    private let video1: VideoModel = VideoModel(title: "1", videoURL: URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!)
    private let video2: VideoModel = VideoModel(title: "2", videoURL: URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!)
    private let video3: VideoModel = VideoModel(title: "3", videoURL: URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!)
    private var videos: [VideoModel] = []

    typealias Models = PlaybackModels
    var router: (NSObjectProtocol & PlaybackRoutingLogic & PlaybackDataPassing)?
    var interactor: PlaybackBusinessLogic?

    // TODO: Presenter에서 받기
    private let viewType: ViewType = .map

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
        PlaybackConfigurator.shared.configure(self)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: VIP Cycle
        videos = [video1, video2, video3]
        setInfiniteScroll()
        setUI()
        configureDataSource()
        playbackCollectionView.delegate = self
        playbackCollectionView.contentInsetAdjustmentBehavior = .never
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initPrevPlayerCell()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        prevPlaybackCell?.playbackView.playerSlider.isHidden = true
        prevPlaybackCell?.playbackView.stopPlayer()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playbackCollectionView.setContentOffset(.init(x: playbackCollectionView.contentOffset.x, y: playbackCollectionView.bounds.height), animated: false)
    }

    // MARK: - UI + Layout

    private func setUI() {
        playbackCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playbackCollectionView)
        NSLayoutConstraint.activate([
            playbackCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            playbackCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playbackCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playbackCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

// MARK: - Playback Method

private extension PlaybackViewController {
    func configureDataSource() {
        guard let tabbarHeight: CGFloat = self.tabBarController?.tabBar.frame.height else {
            return
        }
        playbackCollectionView.register(PlaybackCell.self, forCellWithReuseIdentifier: PlaybackCell.identifier)
        dataSource = UICollectionViewDiffableDataSource<Section, VideoModel>(collectionView: playbackCollectionView) { (collectionView, indexPath, video) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaybackCell.identifier, for: indexPath) as? PlaybackCell else { return PlaybackCell() }
            cell.setPlaybackContents(title: video.title)
            cell.addAVPlayer(url: video.videoURL)
            cell.setPlayerSlider(tabbarHeight: tabbarHeight)
            return cell
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, VideoModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(videos)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    func transDataForInfiniteScroll(_ videos: [VideoModel]) -> [VideoModel] {
        /// Home과 Home을 제외한 나머지(맵, 프로필, 태그)의 무한 스크롤 동작이 다름
        /// Home은 내릴 때마다 Video호출 필요, 나머지는 정해진 양이 있음
        /// Home일 경우는 첫번 째 cell일 때 위로 안올라감.
        /// 모든 동영상을 다 지나쳐야 첫번째 cell로 이동
        var transVideos: [VideoModel] = videos
        if transVideos.count > 0 {
            var tempLastVideoModel: VideoModel = transVideos[transVideos.count-1]
            tempLastVideoModel.id = UUID()
            var tempFirstVideoModel: VideoModel = transVideos[1]
            tempFirstVideoModel.id = UUID()
            transVideos.insert(tempLastVideoModel, at: 0)
            transVideos.append(tempFirstVideoModel)
        }
        return transVideos
    }

    func setInfiniteScroll() {
        if viewType != .home {
            videos = transDataForInfiniteScroll(videos)
        }
    }

    func moveCellAtInfiniteScroll(_ scrollView: UIScrollView) {
        // ViewType이 Home이 아닌 경우
        let count: Int = videos.count
        if count == 0 {
            return
        }
        if viewType == .home {
            // 마지막 Cell에 도달하면 비디오 추가 로드
            // 마지막 Video까지 다 재생했다면 다른 ViewType과 마찬가지로 동작 시작
        }
        // 첫번째에 위치한 마지막 cell에 도달했을 때
        if scrollView.contentOffset.y == 0 {
            scrollView.setContentOffset(.init(x: scrollView.contentOffset.x, y: playbackCollectionView.bounds.height * Double(count - 2)), animated: false)
            checkTelePort = true
        } else if scrollView.contentOffset.y == Double(count-1) * playbackCollectionView.bounds.height {
            scrollView.setContentOffset(.init(x: scrollView.contentOffset.x, y: playbackCollectionView.bounds.height), animated: false)
            checkTelePort = true
        } else {
            normalPlayerScroll(scrollView)
        }

    }

    func normalPlayerScroll(_ scrollView: UIScrollView) {
        let indexPathRow: Int = Int(scrollView.contentOffset.y / playbackCollectionView.frame.height)
        guard let currentPlaybackCell: PlaybackCell = playbackCollectionView.cellForItem(at: IndexPath(row: indexPathRow, section: 0)) as? PlaybackCell else {
            return
        }
        stopPrevPlayerAndPlayCurrnetPlayer(currentPlaybackCell)
        checkTelePort = false
    }

    func initPrevPlayerCell() {
        if prevPlaybackCell == nil {
            prevPlaybackCell = playbackCollectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as? PlaybackCell
        }
        prevPlaybackCell?.playbackView.playerSlider.isHidden = false
        prevPlaybackCell?.playbackView.playPlayer()
    }

    func stopPrevPlayerAndPlayCurrnetPlayer(_ currentPlaybackCell: PlaybackCell) {
        if prevPlaybackCell != currentPlaybackCell {
            prevPlaybackCell?.playbackView.stopPlayer()
            prevPlaybackCell?.playbackView.replayPlayer()
            currentPlaybackCell.playbackView.playPlayer()
            prevPlaybackCell = currentPlaybackCell
            currentPlaybackCell.playbackView.playerSlider.isHidden = false
        }
    }
}

extension PlaybackViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension PlaybackViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        moveCellAtInfiniteScroll(scrollView)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        prevPlaybackCell?.playbackView.playerSlider.isHidden = true
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if checkTelePort {
            let count: Int = videos.count
            guard let currentPlaybackCell: PlaybackCell = cell as? PlaybackCell else {
                return
            }
            if indexPath.row == 1 || indexPath.row == count - 2 {
                stopPrevPlayerAndPlayCurrnetPlayer(currentPlaybackCell)
            }
        }
    }
}
//#Preview {
//    PlaybackViewController()
//}
