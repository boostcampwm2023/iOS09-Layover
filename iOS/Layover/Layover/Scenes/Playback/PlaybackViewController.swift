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

protocol PlaybackDisplayLogic: AnyObject {
    func displayVideoList(viewModel: PlaybackModels.LoadPlaybackVideoList.ViewModel)
    func displayMoveCellIfinfinite()
    func stopPrevPlayerAndPlayCurPlayer(viewModel: PlaybackModels.DisplayPlaybackVideo.ViewModel)
    func setInitialPlaybackCell(viewModel: PlaybackModels.SetInitialPlaybackCell.ViewModel)
    func moveInitialPlaybackCell(viewModel: PlaybackModels.SetInitialPlaybackCell.ViewModel)
    func showPlayerSlider(viewModel: PlaybackModels.DisplayPlaybackVideo.ViewModel)
    func teleportPlaybackCell(viewModel: PlaybackModels.DisplayPlaybackVideo.ViewModel)
    func leavePlaybackView(viewModel: PlaybackModels.DisplayPlaybackVideo.ViewModel)
    func routeToBack(viewModel: PlaybackModels.DisplayPlaybackVideo.ViewModel)
    func configureDataSource(viewModel: PlaybackModels.ConfigurePlaybackCell.ViewModel)
    func seekVideo(viewModel: PlaybackModels.SeekVideo.ViewModel)
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

    private var timeObserverToken: Any?

    private var playerSlider: LOSlider = LOSlider()

    private var dataSource: UICollectionViewDiffableDataSource<Section, Models.PlaybackVideo>?

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
        interactor?.configurePlaybackCell()
        interactor?.displayVideoList()
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
        interactor?.setInitialPlaybackCell()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor?.leavePlaybackView()
        if isMovingFromParent {
            interactor?.moveToBack()
            playerSlider.removeFromSuperview()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        addWindowPlayerSlider()
    }

    private func addWindowPlayerSlider() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        guard let playerSliderWidth: CGFloat = windowScene?.screen.bounds.width else { return }
        guard let windowHeight: CGFloat = windowScene?.screen.bounds.height else { return }
        guard let tabBarHeight: CGFloat = self.tabBarController?.tabBar.frame.height else { return }
        playerSlider.frame = CGRect(x: 0, y: (windowHeight - tabBarHeight - LOSlider.loSliderHeight / 2), width: playerSliderWidth, height: LOSlider.loSliderHeight)
        window?.addSubview(playerSlider)
        playerSlider.window?.windowLevel = UIWindow.Level.normal + 1
    }

    private func setPlayerSlider(at playbackView: PlaybackView) -> Any? {
        let interval: CMTime = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
        let timeObserverToken: Any? = playbackView.playerView.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main , using: { [weak self] currentTime in
            self?.updateSlider(currentTime: currentTime, playerView: playbackView.playerView)
        })
        playerSlider.removeTarget(self, action: #selector(didChangedSliderValue(_:)), for: .valueChanged)
        playerSlider.addTarget(self, action: #selector(didChangedSliderValue(_:)), for: .valueChanged)
        return timeObserverToken
    }

    private func updateSlider(currentTime: CMTime, playerView: PlayerView) {
        guard let currentItem: AVPlayerItem = playerView.player?.currentItem else { return }
        let duration: CMTime = currentItem.duration
        if CMTIME_IS_INVALID(duration) { return }
        playerSlider.value = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
    }

    private func slowShowPlayerSlider() async {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_00)
            playerSlider.isHidden = false
        } catch {
            os_log("Fail Waiting show Player Slider")
        }
    }

    @objc private func didChangedSliderValue(_ sender: LOSlider) {
        let request: Models.SeekVideo.Request = Models.SeekVideo.Request(currentLocation: Float64(sender.value))
        interactor?.controlPlaybackMovie(with: request)
    }

    private func moveToBackViewController() {
        playerSlider.removeFromSuperview()
        interactor?.moveToBack()
    }
}

extension PlaybackViewController: PlaybackDisplayLogic {
    func displayVideoList(viewModel: Models.LoadPlaybackVideoList.ViewModel) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Models.PlaybackVideo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.videos)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    func displayMoveCellIfinfinite() {
        playbackCollectionView.setContentOffset(.init(x: playbackCollectionView.contentOffset.x, y: playbackCollectionView.bounds.height), animated: false)
    }

    func stopPrevPlayerAndPlayCurPlayer(viewModel: PlaybackModels.DisplayPlaybackVideo.ViewModel) {
        if let prevCell = viewModel.prevCell {
            prevCell.playbackView.stopPlayer()
            prevCell.playbackView.replayPlayer()
        }
        if let curCell = viewModel.curCell {
            curCell.playbackView.playPlayer()
            // Slider가 원점으로 돌아가는 시간 필요
            Task {
                await slowShowPlayerSlider()
            }
        }
    }

    func setInitialPlaybackCell(viewModel: PlaybackModels.SetInitialPlaybackCell.ViewModel) {
        guard let currentPlaybackCell: PlaybackCell = playbackCollectionView.cellForItem(at: IndexPath(row: viewModel.indexPathRow, section: 0)) as? PlaybackCell else {
            return
        }
        let request: Models.DisplayPlaybackVideo.Request = Models.DisplayPlaybackVideo.Request(indexPathRow: nil, curCell: currentPlaybackCell)
        interactor?.playInitialPlaybackCell(with: request)
    }

    func showPlayerSlider(viewModel: PlaybackModels.DisplayPlaybackVideo.ViewModel) {
        playerSlider.isHidden = false
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
        playerSlider.isHidden = true
        viewModel.prevCell?.playbackView.stopPlayer()
    }

    func configureDataSource(viewModel: PlaybackModels.ConfigurePlaybackCell.ViewModel) {
        playbackCollectionView.register(PlaybackCell.self, forCellWithReuseIdentifier: PlaybackCell.identifier)
        dataSource = UICollectionViewDiffableDataSource<Section, Models.PlaybackVideo>(collectionView: playbackCollectionView) { (collectionView, indexPath, playbackVideo) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaybackCell.identifier, for: indexPath) as? PlaybackCell else { return PlaybackCell() }
            cell.setPlaybackContents(info: playbackVideo.playbackInfo)
            if let teleportIndex = viewModel.teleportIndex {
                if indexPath.row == 0 || indexPath.row == teleportIndex {
                    return cell
                }
            }
            cell.addAVPlayer(url: playbackVideo.playbackInfo.videoURL)
            cell.timeObserverToken = self.setPlayerSlider(at: cell.playbackView)
            return cell
        }
    }

    func seekVideo(viewModel: PlaybackModels.SeekVideo.ViewModel) {
        let seekTime: CMTime = CMTime(value: CMTimeValue(viewModel.willMoveLocation), timescale: 1)
        viewModel.curCell.playbackView.seekPlayer(seekTime: seekTime)
        viewModel.curCell.playbackView.playPlayer()
    }

    func routeToBack(viewModel: PlaybackModels.DisplayPlaybackVideo.ViewModel) {
        var curCell = viewModel.curCell
        curCell?.playbackView.resetPlayer()
        curCell = nil
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
        let request: Models.DisplayPlaybackVideo.Request = Models.DisplayPlaybackVideo.Request(indexPathRow: indexPathRow, curCell: currentPlaybackCell)
        interactor?.playVideo(with: request)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        playerSlider.isHidden = true
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let currentPlaybackCell: PlaybackCell = cell as? PlaybackCell else {
            return
        }

        let request: Models.DisplayPlaybackVideo.Request = Models.DisplayPlaybackVideo.Request(indexPathRow: indexPath.row, curCell: currentPlaybackCell)
        interactor?.playTeleportVideo(with: request)
    }
}
//#Preview {
//    PlaybackViewController()
//}
