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

    func setPlaybackContents(post: PlaybackModels.DisplayPost) {
        boardID = post.board.boardID
        playbackView.descriptionView.titleLabel.text = post.board.title
        playbackView.descriptionView.setText(post.board.description ?? "")
        playbackView.setDescriptionViewUI()
        playbackView.profileLabel.text = post.member.username
        playbackView.tagStackView.resetTagStackView()
        post.tags.forEach { tag in
            playbackView.tagStackView.addTag(tag)
        }
        playbackView.setProfileButton(member: post.member)
        playbackView.setLocationText(location: transLocation(latitude: post.board.latitude, longitude: post.board.longitude) ?? "이름 모를 곳")
    }

    func addAVPlayer(url: URL) {
        playbackView.resetPlayer()
        playbackView.addAVPlayer(url: url)
        playbackView.setPlayerSlider()
    }

    func addPlayerSlider(tabBarHeight: CGFloat) {
        playbackView.addWindowPlayerSlider(tabBarHeight)

    }

    func resetObserver() {
        playbackView.removeTimeObserver()
        playbackView.removePlayerSlider()
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

    private func transLocation(latitude: Double, longitude: Double) -> String? {
        let findLocation: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-kr")
        var location: String? = nil
        geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { (place, error) in
            if let address: [CLPlacemark] = place {
                location = address.last?.administrativeArea
            }
            if let error {
                os_log(.error, "convert location error: %@", error.localizedDescription)
            }
        }
        return location
    }
}
