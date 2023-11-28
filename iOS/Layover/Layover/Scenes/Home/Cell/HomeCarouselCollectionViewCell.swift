//
//  HomeCarouselCollectionViewCell.swift
//  Layover
//
//  Created by 김인환 on 11/16/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class HomeCarouselCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Components

    private let loopingPlayerView = LoopingPlayerView()

    // MARK: - Properties

    var isPlayingVideos: Bool {
        loopingPlayerView.isPlaying
    }

    // 다른 방법도 많이 알려주세요
    var moveToPlaybackSceneCallback: (() -> Void) = { }

    // MARK: - Object lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
        setConstraints()
    }

    // MARK: - Setup

    private func setUI() {
        backgroundColor = .darkGrey
        layer.cornerRadius = 10
        clipsToBounds = true
    }

    private func setConstraints() {
        contentView.addSubviews(loopingPlayerView)
        [loopingPlayerView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            loopingPlayerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            loopingPlayerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            loopingPlayerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            loopingPlayerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // MARK: - Methods

    func setVideo(url: URL, loopingAt time: TimeInterval) {
        loopingPlayerView.disable()
        loopingPlayerView.prepareVideo(with: url, loopStart: time, duration: 3.0)
        loopingPlayerView.player?.isMuted = true
    }

    func playVideo() {
        loopingPlayerView.play()
    }

    func pauseVideo() {
        loopingPlayerView.pause()
    }

    func LoopingViewAddGesture() {
        let loopingViewGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveToPlaybackScene))
        loopingPlayerView.addGestureRecognizer(loopingViewGesture)
    }

    @objc func moveToPlaybackScene() {
        moveToPlaybackSceneCallback()
        loopingPlayerView.pause()
    }
}
