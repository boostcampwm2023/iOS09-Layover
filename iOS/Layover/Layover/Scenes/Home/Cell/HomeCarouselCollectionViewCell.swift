//
//  HomeCarouselCollectionViewCell.swift
//  Layover
//
//  Created by 김인환 on 11/16/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit
import CoreMedia

final class HomeCarouselCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Components

    private let loopingPlayerView = LoopingPlayerView()

    // MARK: - Properties

    var isPlayingVideos: Bool {
        loopingPlayerView.isPlaying
    }

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

    override func prepareForReuse() {
        loopingPlayerView.disable()
    }

    // MARK: - Methods

    func setVideo(url: URL) {
        loopingPlayerView.prepareVideo(with: url, timeRange: CMTimeRange(start: .zero, end: CMTime(value: 1800, timescale: 600)))
        loopingPlayerView.player?.isMuted = true
    }

    func playVideo() {
        loopingPlayerView.play()
    }

    func pauseVideo() {
        loopingPlayerView.pause()
    }
}
