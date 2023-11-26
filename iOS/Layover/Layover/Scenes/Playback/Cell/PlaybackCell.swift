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

    // TODO: VideoModel 받아서 처리
    func setPlaybackContents(title: String) {
        playbackView.descriptionView.titleLabel.text = title
    }

    func addAVPlayer(url: URL) {
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
    }
}
