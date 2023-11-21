//
//  MapCarouselCollectionViewCell.swift
//  Layover
//
//  Created by kong on 2023/11/17.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit
import AVFoundation

final class MapCarouselCollectionViewCell: UICollectionViewCell {

    private let loopingPlayerView = LoopingPlayerView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        render()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
        render()
    }

    override func prepareForReuse() {
        render()
    }

    func configure(urlString: String) {
        loopingPlayerView.prepareVideo(with: URL(string: urlString)!,
                                       timeRange: CMTimeRange(start: .zero, duration: CMTime(value: 1800, timescale: 600)))
        loopingPlayerView.player?.isMuted = true
    }

    func didMoveToCenter() {
        loopingPlayerView.play()
    }

    func didMoveToSide() {
        loopingPlayerView.pause()
    }

    private func setUI() {
        backgroundColor = .background
        contentView.addSubview(loopingPlayerView)
        loopingPlayerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        loopingPlayerView.topAnchor.constraint(equalTo: contentView.topAnchor),
        loopingPlayerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        loopingPlayerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        loopingPlayerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func render() {
        layer.cornerRadius = 10
        clipsToBounds = true
    }

}