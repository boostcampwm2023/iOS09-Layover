//
//  PlaybackCell.swift
//  Layover
//
//  Created by 황지웅 on 11/24/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class PlaybackCell: UICollectionViewCell {
    let playbackView: PlaybackView = PlaybackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    func setPlaybackContents(video: Post) {
        playbackView.descriptionView.titleLabel.text = video.board.title
        playbackView.descriptionView.setText(video.board.description ?? "")
    }

    func addAVPlayer(url: URL) {
        playbackView.resetPlayer()
        playbackView.addAVPlayer(url: url)
    }

    func setPlayerSlider(tabbarHeight: CGFloat) {
        playbackView.setPlayerSlider()
        playbackView.setPlayerSliderUI(tabbarHeight: tabbarHeight)
    }

    private func configure() {
        playbackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(playbackView)
        NSLayoutConstraint.activate([
            playbackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            playbackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            playbackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playbackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        playbackView.playerSlider.isHidden = true
    }
}
