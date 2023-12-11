//
//  PlaybackCell.swift
//  Layover
//
//  Created by 황지웅 on 11/24/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit
import CoreLocation
import OSLog

final class PlaybackCell: UICollectionViewCell {

    var boardID: Int?

    weak var delegate: PlaybackViewControllerDelegate?

    private var memberID: Int?

    let playbackView: PlaybackView = PlaybackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    override func prepareForReuse() {
        resetObserver()
    }

    func setPlaybackContents(post: PlaybackModels.DisplayedPost) {
        boardID = post.board.boardID
        playbackView.descriptionView.titleLabel.text = post.board.title
        playbackView.descriptionView.setText(post.board.description ?? "")
        playbackView.setDescriptionViewUI()
        playbackView.profileLabel.text = post.member.username
        setTagButtons(with: post.tags)
        memberID = nil
        memberID = post.member.memberID
        playbackView.profileButton.removeTarget(nil, action: nil, for: .allEvents)
        playbackView.profileButton.addTarget(self, action: #selector(profileButtonDidTap), for: .touchUpInside)
    }

    func setProfileImageAndLocation(imageData: Data?, location: String) {
        playbackView.setLocationText(location: location)
        playbackView.setProfileButton(imageData: imageData)
    }

    func addAVPlayer(url: URL) {
        playbackView.resetPlayer()
        playbackView.addAVPlayer(url: url)
        playbackView.setPlayerSlider()
        playbackView.playerView.setVideoFillMode(.resizeAspectFill)
    }

    func addPlayerSlider(tabBarHeight: CGFloat) {
        playbackView.addWindowPlayerSlider(tabBarHeight)

    }

    func resetObserver() {
        playbackView.removeTimeObserver()
        playbackView.removePlayerSlider()
    }

    func isPlaying() -> Bool {
        playbackView.playerView.isPlaying()
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

    private func setTagButtons(with tags: [String]) {
        playbackView.tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
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
            button.addTarget(self, action: #selector(tagButtonDidTap(_:)), for: .touchUpInside)
            playbackView.tagStackView.addArrangedSubview(button)
        }
    }

    @objc private func profileButtonDidTap() {
        guard let memberID else { return }
        delegate?.moveToProfile(memberID: memberID)
    }

    @objc private func tagButtonDidTap(_ sender: UIButton) {
        guard let selectedTag: String = sender.titleLabel?.text else { return }
        delegate?.moveToTagPlay(selectedTag: selectedTag)
    }
}
