//
//  PlaybackViewController.swift
//  Layover
//
//  Created by 황지웅 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit
import AVFoundation

import OSLog

protocol PlaybackViewControllerDelegate: AnyObject {
    func moveToProfile()
    func moveToTagPlay(selectedTag: String)
}

protocol PlaybackDisplayLogic: AnyObject {
    func displayVideoList(viewModel: PlaybackModels.LoadPlaybackVideoList.ViewModel)
    func loadFetchVideos(viewModel: PlaybackModels.LoadPlaybackVideoList.ViewModel)
    func stopPrevPlayerAndPlayCurPlayer(viewModel: PlaybackModels.DisplayPlaybackVideo.ViewModel)
    func setInitialPlaybackCell(viewModel: PlaybackModels.SetInitialPlaybackCell.ViewModel)
    func moveInitialPlaybackCell(viewModel: PlaybackModels.SetInitialPlaybackCell.ViewModel)
    func showPlayerSlider(viewModel: PlaybackModels.DisplayPlaybackVideo.ViewModel)
    func teleportPlaybackCell(viewModel: PlaybackModels.DisplayPlaybackVideo.ViewModel)
    func leavePlaybackView(viewModel: PlaybackModels.DisplayPlaybackVideo.ViewModel)
    func resetVideo(viewModel: PlaybackModels.DisplayPlaybackVideo.ViewModel)
    func configureDataSource(viewModel: PlaybackModels.ConfigurePlaybackCell.ViewModel)
    func seekVideo(viewModel: PlaybackModels.SeekVideo.ViewModel)
    func setSeemoreButton(viewModel: PlaybackModels.SetSeemoreButton.ViewModel)
    func deleteVideo(viewModel: PlaybackModels.DeletePlaybackVideo.ViewModel)
    func routeToProfile()
    func routeToTagPlay()
    func setProfileImageAndLocation(viewModel: PlaybackModels.LoadProfileImageAndLocation.ViewModel)
    func reportVideo()
}

final class PlaybackViewController: BaseViewController {

    // MARK: - Type

    enum Section {
        case main
    }

    // MARK: - UI Components

    private let playbackCollectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()

    // MARK: - Properties

    private var dataSource: UICollectionViewDiffableDataSource<Section, Models.PlaybackVideo>?

    private let seemoreButton: UIBarButtonItem = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        let barButtonItem: UIBarButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.transform = CGAffineTransform(rotationAngle: .pi / 2)
        return barButtonItem
    }()

    typealias Models = PlaybackModels
    var router: (NSObjectProtocol & PlaybackRoutingLogic & PlaybackDataPassing)?
    var interactor: PlaybackBusinessLogic?

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
        Task {
            await interactor?.displayVideoList()
        }
        interactor?.configurePlaybackCell()
        playbackCollectionView.delegate = self
        playbackCollectionView.contentInsetAdjustmentBehavior = .never
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        } catch {
            os_log("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.resumePlaybackView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor?.leavePlaybackView()
        interactor?.hidePlayerSlider()
        if isMovingFromParent {
            interactor?.resetVideo()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        interactor?.setInitialPlaybackCell()
        interactor?.moveInitialPlaybackCell()
    }

    // MARK: - UI + Layout

    override func setConstraints() {
        super.setConstraints()
        playbackCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playbackCollectionView)
        NSLayoutConstraint.activate([
            playbackCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            playbackCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playbackCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playbackCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    override func setUI() {
        super.setUI()
        setSeeMoreButton()
        self.navigationController?.navigationBar.tintColor = .layoverWhite
    }

    private func setSeeMoreButton() {
        guard let button = seemoreButton.customView as? UIButton else { return }
        button.addTarget(self, action: #selector(seeMoreButtonDidTap), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = seemoreButton
    }

    private func reportButtonDidTap(_ indexPathRow: Int) {
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let reportAction: UIAlertAction = UIAlertAction(title: "신고", style: .destructive, handler: {
            [weak self] _ in
            self?.interactor?.reportVideo(with: Models.ReportPlaybackVideo.Request(indexPathRow: indexPathRow))
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: {
            [weak self] _ in
            self?.interactor?.resumeVideo()
        })
        alert.addAction(reportAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: {
            self.interactor?.leavePlaybackView()
        })
    }

    private func deleteButtonDidTap() {
        let visibleIndexPaths = playbackCollectionView.indexPathsForVisibleItems
        if visibleIndexPaths.count > 1 { return }
        guard let currentItemIndex = visibleIndexPaths.first else { return }
        guard let currentItem = dataSource?.itemIdentifier(for: currentItemIndex) else { return }
        let request: Models.DeletePlaybackVideo.Request = Models.DeletePlaybackVideo.Request(playbackVideo: currentItem, indexPathRow: currentItemIndex.row)
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction: UIAlertAction = UIAlertAction(title: "삭제", style: .destructive, handler: {
            [weak self] _ in
            Task {
                await self?.interactor?.deleteVideo(with: request)
            }
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: {
            [weak self] _ in
            self?.interactor?.resumeVideo()
        })
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: {
            self.interactor?.leavePlaybackView()
        })
    }

    @objc private func seeMoreButtonDidTap() {
        let visibleIndexPaths = playbackCollectionView.indexPathsForVisibleItems
        if visibleIndexPaths.count > 1 { return }
        guard let currentItemIndex = visibleIndexPaths.first else { return }
        let request: Models.SetSeemoreButton.Request = Models.SetSeemoreButton.Request(indexPathRow: currentItemIndex.row)
        interactor?.setSeeMoreButton(with: request)
    }
}

extension PlaybackViewController: PlaybackDisplayLogic {
    func displayVideoList(viewModel: Models.LoadPlaybackVideoList.ViewModel) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Models.PlaybackVideo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.videos)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    func loadFetchVideos(viewModel: PlaybackModels.LoadPlaybackVideoList.ViewModel) {
        guard var currentSnapshot = dataSource?.snapshot() else { return }
        currentSnapshot.appendItems(viewModel.videos)
        dataSource?.apply(currentSnapshot, animatingDifferences: true)
    }

    func stopPrevPlayerAndPlayCurPlayer(viewModel: PlaybackModels.DisplayPlaybackVideo.ViewModel) {
        guard let tabBarHeight: CGFloat = self.tabBarController?.tabBar.frame.height else { return }
        if let previousCell = viewModel.previousCell {
            previousCell.playbackView.removePlayerSlider()
            previousCell.playbackView.stopPlayer()
            previousCell.playbackView.replayPlayer()
        }
        if let currentCell = viewModel.currentCell, !currentCell.isPlaying() {
            currentCell.addPlayerSlider(tabBarHeight: tabBarHeight)
            currentCell.playbackView.addTargetPlayerSlider()
            currentCell.playbackView.playPlayer()
        }
    }

    func setInitialPlaybackCell(viewModel: PlaybackModels.SetInitialPlaybackCell.ViewModel) {
        guard let currentPlaybackCell: PlaybackCell = playbackCollectionView.cellForItem(at: IndexPath(row: viewModel.indexPathRow, section: 0)) as? PlaybackCell else {
            return
        }
        let request: Models.DisplayPlaybackVideo.Request = Models.DisplayPlaybackVideo.Request(indexPathRow: nil, currentCell: currentPlaybackCell)
        interactor?.playInitialPlaybackCell(with: request)
    }

    func showPlayerSlider(viewModel: PlaybackModels.DisplayPlaybackVideo.ViewModel) {
        viewModel.currentCell?.playbackView.playerSlider?.isHidden = false
    }

    func moveInitialPlaybackCell(viewModel: PlaybackModels.SetInitialPlaybackCell.ViewModel) {
        let willMoveLocation: CGFloat = CGFloat(viewModel.indexPathRow) * playbackCollectionView.bounds.height
        playbackCollectionView.setContentOffset(.init(x: playbackCollectionView.contentOffset.x, y: willMoveLocation), animated: false)
    }

    func teleportPlaybackCell(viewModel: PlaybackModels.DisplayPlaybackVideo.ViewModel) {
        guard let indexPathRow = viewModel.indexPathRow else { return }
        let willTeleportlocation: CGFloat = CGFloat(indexPathRow) * playbackCollectionView.bounds.height
        playbackCollectionView.setContentOffset(.init(x: playbackCollectionView.contentOffset.x, y: willTeleportlocation), animated: false)
    }

    func leavePlaybackView(viewModel: PlaybackModels.DisplayPlaybackVideo.ViewModel) {
        viewModel.previousCell?.playbackView.stopPlayer()
    }

    func configureDataSource(viewModel: PlaybackModels.ConfigurePlaybackCell.ViewModel) {
        playbackCollectionView.register(PlaybackCell.self, forCellWithReuseIdentifier: PlaybackCell.identifier)
        dataSource = UICollectionViewDiffableDataSource<Section, Models.PlaybackVideo>(collectionView: playbackCollectionView) { (collectionView, indexPath, playbackVideo) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaybackCell.identifier, for: indexPath) as? PlaybackCell else { return PlaybackCell() }
            cell.setPlaybackContents(post: playbackVideo.displayedPost)
            if let teleportIndex = viewModel.teleportIndex {
                if indexPath.row == 0 || indexPath.row == teleportIndex {
                    cell.playbackView.resetPlayer()
                    return cell
                }
            }
            cell.addAVPlayer(url: playbackVideo.displayedPost.board.videoURL)
            Task {
                await self.interactor?.loadProfileImageAndLocation(with: Models.LoadProfileImageAndLocation.Request(
                    curCell: cell,
                    profileImageURL: playbackVideo.displayedPost.member.profileImageURL,
                    latitude: playbackVideo.displayedPost.board.latitude,
                    longitude: playbackVideo.displayedPost.board.longitude))
            }
            cell.delegate = self
            return cell
        }
    }

    func seekVideo(viewModel: PlaybackModels.SeekVideo.ViewModel) {
        let seekTime: CMTime = CMTime(value: CMTimeValue(viewModel.willMoveLocation), timescale: 1)
        viewModel.currentCell.playbackView.seekPlayer(seekTime: seekTime)
        viewModel.currentCell.playbackView.playPlayer()
    }

    func resetVideo(viewModel: PlaybackModels.DisplayPlaybackVideo.ViewModel) {
        var currentCell = viewModel.currentCell
        currentCell?.resetObserver()
        currentCell?.playbackView.resetPlayer()
        currentCell = nil
    }

    func setSeemoreButton(viewModel: Models.SetSeemoreButton.ViewModel) {
        switch viewModel.buttonType {
        case .delete:
            deleteButtonDidTap()
        case .report:
            reportButtonDidTap(viewModel.indexPathRow)
        }
    }

    func deleteVideo(viewModel: PlaybackModels.DeletePlaybackVideo.ViewModel) {
        interactor?.resetVideo()
        guard let dataSource else { return }
        var snapshot = dataSource.snapshot()
        if viewModel.nextCellIndex == 2 && snapshot.itemIdentifiers.count == 2 {
            self.navigationController?.popViewController(animated: true)
        }
        if let nextCellIndex = viewModel.nextCellIndex, let deleteCellIndex = viewModel.deleteCellIndex {
            let insertItem = snapshot.itemIdentifiers[nextCellIndex]
            let deleteItem = snapshot.itemIdentifiers[deleteCellIndex]
            let newFrontDummyItem = Models.PlaybackVideo(displayedPost: insertItem.displayedPost)
            snapshot.insertItems([newFrontDummyItem], beforeItem: deleteItem)
            snapshot.deleteItems([deleteItem])
            if viewModel.isNeedReplace {
                // 삭제가 되어도 더미셀이 오지 않고 정상적으로 순회하기 위함
                let newBehindItem = Models.PlaybackVideo(displayedPost: insertItem.displayedPost)
                snapshot.insertItems([newBehindItem], afterItem: viewModel.playbackVideo)
                snapshot.deleteItems([insertItem])
            }
            dataSource.apply(snapshot, animatingDifferences: false)
        }
        snapshot.deleteItems([viewModel.playbackVideo])
        dataSource.apply(snapshot, animatingDifferences: true)
        if snapshot.itemIdentifiers.count < 1 {
            self.navigationController?.popViewController(animated: true)
        }
    }

    func routeToProfile() {
        router?.routeToProfile()
    }

    func routeToTagPlay() {
        router?.routeToTagPlay()
    }

    func setProfileImageAndLocation(viewModel: PlaybackModels.LoadProfileImageAndLocation.ViewModel) {
        viewModel.curCell.setProfileImageAndLocation(imageData: viewModel.profileImageData, location: viewModel.location)
    }

    func reportVideo() {
        router?.routeToReport()
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
        let indexPathRow: Int = Int(scrollView.contentOffset.y / playbackCollectionView.frame.height)
        guard let currentPlaybackCell: PlaybackCell = playbackCollectionView.cellForItem(at: IndexPath(row: indexPathRow, section: 0)) as? PlaybackCell else {
            return
        }
        let request: Models.DisplayPlaybackVideo.Request = Models.DisplayPlaybackVideo.Request(indexPathRow: indexPathRow, currentCell: currentPlaybackCell)
        interactor?.playVideo(with: request)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        interactor?.hidePlayerSlider()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let currentPlaybackCell: PlaybackCell = cell as? PlaybackCell else {
            return
        }

        let request: Models.DisplayPlaybackVideo.Request = Models.DisplayPlaybackVideo.Request(indexPathRow: indexPath.row, currentCell: currentPlaybackCell)
        interactor?.playTeleportVideo(with: request)
        interactor?.careVideoLoading(with: request)
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let currentPlaybackCell: PlaybackCell = cell as? PlaybackCell else {
            return
        }

        let request: Models.DisplayPlaybackVideo.Request = Models.DisplayPlaybackVideo.Request(indexPathRow: indexPath.row, currentCell: currentPlaybackCell)
        interactor?.playTeleportVideoOnlyOneCell(with: request)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset < currentOffset {
            Task {
                await interactor?.fetchPosts()
            }
        }
    }
}

extension PlaybackViewController: PlaybackViewControllerDelegate {
    func moveToProfile() {
        let indexPaths = playbackCollectionView.indexPathsForVisibleItems
        if indexPaths.count == 1, let indexPath = indexPaths.first {
            let request: Models.MoveToRelativeView.Request = Models.MoveToRelativeView.Request(indexPathRow: indexPath.row, selectedTag: nil)
            interactor?.moveToProfile(with: request)
        }
    }

    func moveToTagPlay(selectedTag: String) {
        let request: Models.MoveToRelativeView.Request = Models.MoveToRelativeView.Request(indexPathRow: nil, selectedTag: selectedTag)
        interactor?.moveToTagPlay(with: request)
    }
}
//#Preview {
//    PlaybackViewController()
//}
