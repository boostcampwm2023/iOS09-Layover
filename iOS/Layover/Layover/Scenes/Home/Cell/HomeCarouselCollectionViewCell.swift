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

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .layoverWhite
        label.font = UIFont.loFont(type: .subtitle)
        return label
    }()

    private let tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()

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
        contentView.addSubviews(loopingPlayerView, thumbnailImageView, titleLabel, tagStackView)
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            loopingPlayerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            loopingPlayerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            loopingPlayerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            loopingPlayerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            tagStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -23),
            tagStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            tagStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            tagStackView.heightAnchor.constraint(equalToConstant: 25),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            titleLabel.bottomAnchor.constraint(equalTo: tagStackView.topAnchor, constant: -18)
        ])
    }

    // MARK: - Methods

    func setVideo(url: URL, loopingAt time: TimeInterval) {
        loopingPlayerView.disable()
        loopingPlayerView.prepareVideo(with: url, loopStart: time, duration: 3.0)
        loopingPlayerView.player?.isMuted = true
    }

    func configure(title: String, tags: [String]) {
        titleLabel.text = title
        setTagButtons(with: tags)
    }

    private func setTagButtons(with tags: [String]) {
        tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        tags.forEach {
            var configuration = UIButton.Configuration.filled()
            configuration.baseBackgroundColor = UIColor.primaryPurple
            configuration.title = $0
            configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.loFont(ofSize: 13, weight: .bold)
                outgoing.foregroundColor = UIColor.layoverWhite
                return outgoing
            }
            let button = UIButton(configuration: configuration)
            button.clipsToBounds = true
            button.layer.cornerRadius = 12
            tagStackView.addArrangedSubview(button)
        }
        tagStackView.addArrangedSubview(UIView())
    }

    func configure(thumbnailImage: UIImage) {
        thumbnailImageView.image = thumbnailImage
    }

    func playVideo() {
        thumbnailImageView.isHidden = true
        loopingPlayerView.play()
    }

    func pauseVideo() {
        thumbnailImageView.isHidden = false
        loopingPlayerView.pause()
    }
}
