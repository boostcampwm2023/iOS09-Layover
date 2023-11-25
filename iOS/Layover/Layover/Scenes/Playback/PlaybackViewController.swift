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
    func displayFetchFromLocalDataStore(with viewModel: PlaybackModels.FetchFromLocalDataStore.ViewModel)
    func displayFetchFromRemoteDataStore(with viewModel: PlaybackModels.FetchFromRemoteDataStore.ViewModel)
    func displayTrackAnalytics(with viewModel: PlaybackModels.TrackAnalytics.ViewModel)
    func displayPerformPlayback(with viewModel: PlaybackModels.PerformPlayback.ViewModel)
}

final class PlaybackViewController: UIViewController, PlaybackDisplayLogic {

//    private let playerSlider: LOSlider = LOSlider()

    private let playbackCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private var dataSource: UICollectionViewDiffableDataSource<UUID, URL>?

    private var prevPlaybackCell: PlaybackCell?

    // MARK: - Properties

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
        let viewController = self
        let interactor = PlaybackInteractor()
        let presenter = PlaybackPresenter()
        let router = PlaybackRouter()

        viewController.router = router
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupFetchFromLocalDataStore()
        configureDataSource()
        setUI()
        playbackCollectionView.delegate = self
        playbackCollectionView.contentInsetAdjustmentBehavior = .never
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchFromRemoteDataStore()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if prevPlaybackCell == nil {
            prevPlaybackCell = playbackCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? PlaybackCell
        } else {
            prevPlaybackCell?.playbackView.playPlayer()
        }
        trackScreenViewAnalytics()
        registerNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        prevPlaybackCell?.playbackView.playerSlider.isHidden = true
        prevPlaybackCell?.playbackView.stopPlayer()
        unregisterNotifications()
    }

    // MARK: - UI + Layout

    private func setUI() {
        playbackCollectionView.showsVerticalScrollIndicator = false
        playbackCollectionView.isPagingEnabled = true
        playbackCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playbackCollectionView)
        NSLayoutConstraint.activate([
            playbackCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            playbackCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playbackCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playbackCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    // MARK: - Notifications

    func registerNotifications() {
        let selector = #selector(trackScreenViewAnalytics)
        let notification = UIApplication.didBecomeActiveNotification
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }

    func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Use Case - Fetch From Local DataStore

    @IBOutlet var exampleLocalLabel: UILabel! = UILabel()
    func setupFetchFromLocalDataStore() {
        let request = Models.FetchFromLocalDataStore.Request()
        interactor?.fetchFromLocalDataStore(with: request)
    }

    func displayFetchFromLocalDataStore(with viewModel: PlaybackModels.FetchFromLocalDataStore.ViewModel) {
        exampleLocalLabel.text = viewModel.exampleTranslation
    }

    // MARK: - Use Case - Fetch From Remote DataStore

    @IBOutlet var exampleRemoteLabel: UILabel! = UILabel()
    func setupFetchFromRemoteDataStore() {
        let request = Models.FetchFromRemoteDataStore.Request()
        interactor?.fetchFromRemoteDataStore(with: request)
    }

    func displayFetchFromRemoteDataStore(with viewModel: PlaybackModels.FetchFromRemoteDataStore.ViewModel) {
        exampleRemoteLabel.text = viewModel.exampleVariable
    }

    // MARK: - Use Case - Track Analytics

    @objc
    func trackScreenViewAnalytics() {
        trackAnalytics(event: .screenView)
    }

    func trackAnalytics(event: PlaybackModels.AnalyticsEvents) {
        let request = Models.TrackAnalytics.Request(event: event)
        interactor?.trackAnalytics(with: request)
    }

    func displayTrackAnalytics(with viewModel: PlaybackModels.TrackAnalytics.ViewModel) {
        // do something after tracking analytics (if needed)
    }

    // MARK: - Use Case - Playback

    func performPlayback(_ sender: Any) {
        let request = Models.PerformPlayback.Request(exampleVariable: exampleLocalLabel.text)
        interactor?.performPlayback(with: request)
    }

    func displayPerformPlayback(with viewModel: PlaybackModels.PerformPlayback.ViewModel) {
        // handle error and ui element error states
        // based on error type
        if let error = viewModel.error {
            switch error.type {
            case .emptyExampleVariable:
                exampleLocalLabel.text = error.message

            case .networkError:
                exampleLocalLabel.text = error.message
            }

            return
        }

        // handle ui element success state and
        // route to next screen
        router?.routeToNext()
    }
}

// MARK: - Playback Method

private extension PlaybackViewController {
    func configureDataSource() {
        guard let tabbarHeight: CGFloat = self.tabBarController?.tabBar.frame.height else {
            return
        }
        let cellRegistration = UICollectionView.CellRegistration<PlaybackCell, URL> { (cell, _, url) in
            cell.addAVPlayer(url: url)
            cell.setPlayerSlider(tabbarHeight: tabbarHeight)
        }

        dataSource = UICollectionViewDiffableDataSource<UUID, URL>(collectionView: playbackCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, url: URL) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: url)
        }

        var snapshot = NSDiffableDataSourceSnapshot<UUID, URL>()
        snapshot.appendSections([UUID()])
        snapshot.appendItems([URL(string: "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8")!, URL(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")!])
        dataSource?.apply(snapshot, animatingDifferences: false)
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
        // 추후 무한 스크롤 처리 예정
        let indexPathRow: Int = Int(scrollView.contentOffset.y / playbackCollectionView.frame.height)
        guard let currentPlaybackCell: PlaybackCell = playbackCollectionView.cellForItem(at: IndexPath(row: indexPathRow, section: 0)) as? PlaybackCell else {
            return
        }

        if prevPlaybackCell != currentPlaybackCell {
            prevPlaybackCell?.playbackView.stopPlayer()
            prevPlaybackCell?.playbackView.replayPlayer()
            currentPlaybackCell.playbackView.playPlayer()
            prevPlaybackCell = currentPlaybackCell
        }
        currentPlaybackCell.playbackView.playerSlider.isHidden = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        prevPlaybackCell?.playbackView.playerSlider.isHidden = true
    }
}
//#Preview {
//    PlaybackViewController()
//}
