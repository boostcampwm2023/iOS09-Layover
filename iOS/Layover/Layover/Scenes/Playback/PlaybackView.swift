//
//  PlaybackView.swift
//  Layover
//
//  Created by 황지웅 on 11/24/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit
import AVFoundation
import HLSCachingServer

final class PlaybackView: UIView {

    // MARK: - Properties

    private var timeObserverToken: Any?

    private var playerObserverToken: Any?

    // MARK: - UI Components
    // TODO: private 다시 붙이고 Method 처리
    lazy var descriptionView: LODescriptionView = {
        let descriptionView: LODescriptionView = LODescriptionView()
        descriptionView.clipsToBounds = true
        return descriptionView
    }()

    private lazy var descriptionViewHeight: NSLayoutConstraint? = descriptionView.heightAnchor.constraint(equalToConstant: LODescriptionView.descriptionHeight)
    private lazy var titleTopAnchor: NSLayoutConstraint? = descriptionView.titleLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor)

    private let gradientLayer: CAGradientLayer = {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: LODescriptionView.descriptionWidth, height: LODescriptionView.descriptionHeight)
        let colors: [CGColor] = [UIColor.layoverWhite.cgColor, UIColor.clear.cgColor]
        gradientLayer.colors = colors
        gradientLayer.opacity = 0.8
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        return gradientLayer
    }()

    let tagStackView: LOTagStackView = {
        let tagStackView: LOTagStackView = LOTagStackView(style: .basic)
        return tagStackView
    }()

    let profileButton: UIButton = {
        let button: UIButton = UIButton()
        button.layer.cornerRadius = 19
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.grey400.cgColor
        button.backgroundColor = .layoverWhite
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()

    let profileLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .loFont(type: .body2Bold)
        label.textColor = UIColor.layoverWhite
        label.text = "@Layover"
        return label
    }()

    private let locationLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .loFont(type: .body2)
        label.text = "이름 모를 곳에서"
        label.textColor = UIColor.layoverWhite
        return label
    }()

    private lazy var pauseImage: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage.pause
        imageView.alpha = 0.0
        return imageView
    }()

    private lazy var playImage: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage.play
        imageView.alpha = 0.0
        return imageView
    }()

    let playerView: PlayerView = PlayerView()

    var playerSlider: LOSlider?

    // MARK: - View Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setPlayerView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
        setPlayerView()
    }

    // MARK: Player Setting Method

    func addAVPlayer(url: URL) {
        guard let reverseProxyURL = HLSCachingServer.reverseProxyURL(from: url) else { return }
        playerView.player = AVPlayer(url: reverseProxyURL)
    }

    func getPlayerItemStatus() -> AVPlayerItem.Status? {
        playerView.player?.currentItem?.status
    }

    // MARK: Player Play Method

    func stopPlayer() {
        playerView.pause()
        NotificationCenter.default.removeObserver(self)
    }

    func playPlayer() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: playerView.player?.currentItem)
        playerView.play()
    }

    func replayPlayer() {
        playerView.seek(to: .zero)
    }

    func resetPlayer() {
        playerView.resetPlayer()
    }

    func seekPlayer(seekTime: CMTime) {
        playerView.seek(to: seekTime)
    }

    func getDuration() -> Float64 {
        CMTimeGetSeconds(playerView.player?.currentItem?.duration ?? CMTime(value: 0, timescale: 1))
    }

    func removePlayerSlider() {
        guard let playerSlider = playerSlider else { return }
        playerSlider.removeTarget(self, action: #selector(didChangedSliderValue(_:)), for: .valueChanged)
        playerSlider.removeFromSuperview()
    }

    func addWindowPlayerSlider(_ tabBarHeight: CGFloat) {
        playerSlider = LOSlider()
        guard let playerSlider else { return }
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        guard let playerSliderWidth: CGFloat = windowScene?.screen.bounds.width else { return }
        guard let windowHeight: CGFloat = windowScene?.screen.bounds.height else { return }
        playerSlider.frame = CGRect(x: 0, y: (windowHeight - tabBarHeight - LOSlider.loSliderHeight / 2), width: playerSliderWidth, height: LOSlider.loSliderHeight)
        window?.addSubview(playerSlider)
        playerSlider.window?.windowLevel = UIWindow.Level.normal + 1
    }

    func setPlayerSlider() {
        let interval: CMTime = CMTimeMakeWithSeconds(0.2, preferredTimescale: Int32(NSEC_PER_SEC))
        timeObserverToken =  playerView.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] currentTime in
            self?.updateSlider(currentTime: currentTime)
        })
    }

    func addTargetPlayerSlider() {
        playerSlider?.addTarget(self, action: #selector(didChangedSliderValue(_:)), for: .valueChanged)
    }

    func removeTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            playerView.player?.removeTimeObserver(timeObserverToken)
        }
        timeObserverToken = nil
    }

    func setDescriptionViewUI() {
        if descriptionView.checkLabelOverflow() {
            let size: CGSize = CGSize(width: LODescriptionView.descriptionWidth, height: .infinity)
            let estimatedSize: CGSize = descriptionView.descriptionLabel.sizeThatFits(size)
            let totalHeight: CGFloat = estimatedSize.height + descriptionView.titleLabel.intrinsicContentSize.height
            descriptionViewHeight?.isActive = false
            titleTopAnchor?.isActive = false
            descriptionViewHeight = descriptionView.heightAnchor.constraint(equalToConstant: totalHeight)
            descriptionViewHeight?.isActive = true
            titleTopAnchor = descriptionView.titleLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: totalHeight - LODescriptionView.descriptionHeight)
            titleTopAnchor?.isActive = true
            descriptionView.descriptionLabel.layer.mask = gradientLayer
            addDescriptionAnimateGesture()
        } else {
            descriptionView.descriptionLabel.layer.mask = nil
            descriptionViewHeight?.isActive = false
            descriptionViewHeight = descriptionView.heightAnchor.constraint(equalToConstant: LODescriptionView.descriptionHeight)
            descriptionViewHeight?.isActive = true
            titleTopAnchor?.isActive = false
            titleTopAnchor = descriptionView.titleLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor)
            titleTopAnchor?.isActive = true
            removeDescriptionAnimateGesture()
        }
    }

    func setProfileButton(imageData: Data?) {
        if let imageData {
            profileButton.setImage(UIImage(data: imageData), for: .normal)
        } else {
            profileButton.setImage(UIImage.profile, for: .normal)
        }
    }

    func setLocationText(location: String) {
        locationLabel.text = "\(location)에서"
    }

}

// MARK: PlaybackView 내부에서만 쓰이는 Method

private extension PlaybackView {
    func updateSlider(currentTime: CMTime) {
        guard let currentItem: AVPlayerItem = playerView.player?.currentItem else { return }
        let duration: CMTime = currentItem.duration
        if CMTIME_IS_INVALID(duration) { return }
        playerSlider?.value = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
    }

    // MARK: - Gesture Method

    func setPlayerView() {
        let playerViewGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playerViewDidTap))
        self.addGestureRecognizer(playerViewGesture)
    }

    func addDescriptionAnimateGesture() {
        let descriptionViewGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(descriptionViewDidTap(_:)))
        for recognizer in descriptionView.descriptionLabel.gestureRecognizers ?? [] {
            descriptionView.descriptionLabel.removeGestureRecognizer(recognizer)
        }
        descriptionView.descriptionLabel.addGestureRecognizer(descriptionViewGesture)
    }

    func removeDescriptionAnimateGesture() {
        for recognizer in descriptionView.descriptionLabel.gestureRecognizers ?? [] {
            descriptionView.descriptionLabel.removeGestureRecognizer(recognizer)
        }
    }

    // MARK: - UI Method

    func setSubViewsInPlayerViewConstraints() {
        [descriptionView, tagStackView, profileButton, profileLabel, locationLabel, pauseImage, playImage].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        playerView.addSubviews(descriptionView, tagStackView, profileButton, profileLabel, locationLabel, pauseImage, playImage)
        NSLayoutConstraint.activate([
            descriptionView.bottomAnchor.constraint(equalTo: tagStackView.topAnchor, constant: -11),
            descriptionView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 20),
            descriptionView.widthAnchor.constraint(equalToConstant: LODescriptionView.descriptionWidth),

            tagStackView.bottomAnchor.constraint(equalTo: profileButton.topAnchor, constant: -20),
            tagStackView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 20),
            tagStackView.heightAnchor.constraint(equalToConstant: 25),

            profileButton.bottomAnchor.constraint(equalTo: playerView.bottomAnchor, constant: -20),
            profileButton.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 20),
            profileButton.widthAnchor.constraint(equalToConstant: 38),
            profileButton.heightAnchor.constraint(equalToConstant: 38),

            profileLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor),
            profileLabel.leadingAnchor.constraint(equalTo: profileButton.trailingAnchor, constant: 14),

            locationLabel.leadingAnchor.constraint(equalTo: profileButton.trailingAnchor, constant: 14),
            locationLabel.bottomAnchor.constraint(equalTo: playerView.safeAreaLayoutGuide.bottomAnchor, constant: -19),

            pauseImage.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
            pauseImage.centerYAnchor.constraint(equalTo: playerView.centerYAnchor),
            pauseImage.widthAnchor.constraint(equalToConstant: 65),
            pauseImage.heightAnchor.constraint(equalToConstant: 65),

            playImage.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
            playImage.centerYAnchor.constraint(equalTo: playerView.centerYAnchor),
            playImage.widthAnchor.constraint(equalToConstant: 65),
            playImage.heightAnchor.constraint(equalToConstant: 65)
        ])
    }

    func setUI() {
        playerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(playerView)

        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: self.topAnchor),
            playerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
        setSubViewsInPlayerViewConstraints()
    }

    // MARK: Gesture

    @objc func descriptionViewDidTap(_ sender: UITapGestureRecognizer) {
            if self.descriptionView.state == .hidden {
                let size = CGSize(width: LODescriptionView.descriptionWidth, height: .infinity)
                let estimatedSize = descriptionView.descriptionLabel.sizeThatFits(size)
                let totalHeight: CGFloat = estimatedSize.height + descriptionView.titleLabel.intrinsicContentSize.height
                UIView.animate(withDuration: 0.5, animations: {
                    self.descriptionView.descriptionLabel.layer.mask = nil
                }, completion: { _ in
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                        self.descriptionView.titleLabel.transform = CGAffineTransform(translationX: 0, y: -(totalHeight - LODescriptionView.descriptionHeight))
                        self.descriptionView.descriptionLabel.transform = CGAffineTransform(translationX: 0, y: -(totalHeight - LODescriptionView.descriptionHeight))
                    })
                })
                self.descriptionView.state = .show
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.descriptionView.descriptionLabel.transform = .identity
                    self.descriptionView.titleLabel.transform = .identity
                }, completion: { _ in
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                        self.descriptionView.descriptionLabel.layer.mask = self.gradientLayer
                    })
                })
                self.descriptionView.state = .hidden
            }
    }

    @objc func playerViewDidTap() {
        let scale: CGFloat = 1.2
        if !playerView.isPlaying() {
            UIView.animate(withDuration: 0.5, animations: {
                self.playImage.transform = CGAffineTransform(scaleX: scale, y: scale)
                self.playImage.alpha = 0.8
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    self.playImage.transform = .identity
                    self.playImage.alpha = 0.0
                })
            })
            playerView.play()
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.pauseImage.transform = CGAffineTransform(scaleX: scale, y: scale)
                self.pauseImage.alpha = 0.8
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    self.pauseImage.transform = .identity
                    self.pauseImage.alpha = 0.0
                })
            })
            playerView.pause()
        }
    }

    // MARK: Selector

    @objc func playerDidFinishPlaying(note: NSNotification) {
        playerView.seek(to: CMTime.zero)
        playerView.play()
    }

    @objc private func didChangedSliderValue(_ sender: LOSlider) {
        guard let duration: CMTime = playerView.player?.currentItem?.duration else { return }
        let value: Float64 = Float64(sender.value) * CMTimeGetSeconds(duration)
        let seekTime: CMTime = CMTime(value: CMTimeValue(value), timescale: 1)
        playerView.seek(to: seekTime)
        playerView.play()
    }
}
