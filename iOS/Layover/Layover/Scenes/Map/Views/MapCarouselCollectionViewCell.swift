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

    private let thumbnailImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

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

    func setVideo(url: URL) {
        loopingPlayerView.disable()
        loopingPlayerView.prepareVideo(with: url,
                                       timeRange: CMTimeRange(start: .zero, duration: CMTime(value: 1800, timescale: 600)))
        loopingPlayerView.player?.isMuted = true
    }

    func configure(thumbnailImageData: Data) {
        thumbnailImageView.image = UIImage(data: thumbnailImageData)
    }

    func play() {
        loopingPlayerView.play()
        thumbnailImageView.isHidden = true
    }

    func pause() {
        loopingPlayerView.pause()
        thumbnailImageView.isHidden = false
    }


    private func setUI() {
        backgroundColor = .background
        contentView.addSubviews(loopingPlayerView, thumbnailImageView)
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            loopingPlayerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            loopingPlayerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            loopingPlayerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            loopingPlayerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func render() {
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}
