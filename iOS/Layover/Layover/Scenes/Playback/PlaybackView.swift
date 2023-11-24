//
//  PlaybackView.swift
//  Layover
//
//  Created by 황지웅 on 11/24/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit
import AVFoundation

final class PlaybackView: UIView {
    private let descriptionView: LODescriptionView = {
        let descriptionView: LODescriptionView = LODescriptionView()
        descriptionView.setText("밤새 모니터에 튀긴 침이 마르기도 전에 대기실로 아참 교수님이 문신 땜에 긴팔 입고 오래 난 시작도 전에 눈을 감았지")
        descriptionView.clipsToBounds = true
        return descriptionView
    }()

    private let descriptionViewHeight: NSLayoutConstraint! = nil

    private let gradientLayer: CAGradientLayer = {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: LODescriptionView.descriptionWidth, height: LODescriptionView.descriptionHeight)
        let colors: [CGColor] = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        return gradientLayer
    }()

    private let tagStackView: LOTagStackView = {
        let tagStackView: LOTagStackView = LOTagStackView()
        return tagStackView
    }()

    private let profileButton: UIButton = {
        let button: UIButton = UIButton()
        button.layer.cornerRadius = 19
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.layoverWhite.cgColor
//        button.setImage(UIImage(systemName: "cancel"), for: .normal)
        button.backgroundColor = .layoverWhite
        return button
    }()

    private let profileLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .loFont(type: .body2Bold)
        label.textColor = UIColor.layoverWhite
        label.text = "@Layover"
        return label
    }()

    private let locationLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .loFont(type: .body2)
        label.textColor = UIColor.layoverWhite
        label.text = "파리"
        return label
    }()

    private let pauseImage: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage.pause
        imageView.isHidden = true
        imageView.alpha = 0.4
        return imageView
    }()

    private let playImage: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage.play
        imageView.isHidden = true
        imageView.alpha = 0.4
        return imageView
    }()

    private let playerView: PlayerView = PlayerView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setPlayerView(url: URL(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")!)
        addDescriptionAnimateGesture()
        setSubViewsInPlayerViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setPlayerView(url: URL(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")!)
        addDescriptionAnimateGesture()
        setUI()
    }
}

extension PlaybackView {
    func setPlayerView(url: URL) {
        let playerViewGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playerViewDidTap))
        playerView.addGestureRecognizer(playerViewGesture)
        playerView.player = AVPlayer(url: url)
//        if playerView.player?.currentItem?.status == .readyToPlay {
//            playerSlider.minimumValue = 0
//            playerSlider.maximumValue = 1
//        }
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: playerView.player?.currentItem)
    }

    func addDescriptionAnimateGesture() {
        let descriptionViewGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(descriptionViewDidTap(_:)))
        descriptionView.descriptionLabel.addGestureRecognizer(descriptionViewGesture)
    }

    func setDescriptionViewUI() {
        let size: CGSize = CGSize(width: LODescriptionView.descriptionWidth, height: .infinity)
        let estimatedSize: CGSize = descriptionView.descriptionLabel.sizeThatFits(size)
        let totalHeight: CGFloat = estimatedSize.height + descriptionView.titleLabel.intrinsicContentSize.height
        descriptionView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
        descriptionView.titleLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: totalHeight - LODescriptionView.descriptionHeight).isActive = true
        if descriptionView.checkLabelOverflow() {
            descriptionView.descriptionLabel.layer.addSublayer(gradientLayer)
        }
    }

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
        setDescriptionViewUI()
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

    @objc func didChangedSliderValue(_ sender: LOSlider) {
        guard let duration: CMTime = playerView.player?.currentItem?.duration else {
            return
        }
        let value: Float64 = Float64(sender.value) * CMTimeGetSeconds(duration)
        let seekTime: CMTime = CMTime(value: CMTimeValue(value), timescale: 1)
        playerView.seek(to: seekTime)
        playerView.play()
    }

    @objc func descriptionViewDidTap(_ sender: UITapGestureRecognizer) {
            if self.descriptionView.state == .hidden {
                let size = CGSize(width: LODescriptionView.descriptionWidth, height: .infinity)
                let estimatedSize = descriptionView.descriptionLabel.sizeThatFits(size)
                let totalHeight: CGFloat = estimatedSize.height + descriptionView.titleLabel.intrinsicContentSize.height
                UIView.animate(withDuration: 0.3,animations: {
                    self.descriptionView.titleLabel.transform = CGAffineTransform(translationX: 0, y: -(totalHeight - LODescriptionView.descriptionHeight))
                    self.descriptionView.descriptionLabel.transform = CGAffineTransform(translationX: 0, y: -(totalHeight - LODescriptionView.descriptionHeight))
                    self.gradientLayer.isHidden = true
                })
                self.descriptionView.state = .show
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.descriptionView.descriptionLabel.transform = .identity
                    self.descriptionView.titleLabel.transform = .identity
                    self.gradientLayer.isHidden = false
                })
                self.descriptionView.state = .hidden
            }
    }

    @objc func playerViewDidTap() {
        if !playerView.isPlaying() {
            UIView.transition(with: playImage, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.playImage.isHidden = false
            }, completion: { _ in
                UIView.transition(with: self.playImage, duration: 0.5, animations: {
                    self.playImage.isHidden = true
                })
            })
            playerView.play()
        } else {
            UIView.transition(with: pauseImage, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.pauseImage.isHidden = false
            }, completion: { _ in
                UIView.transition(with: self.pauseImage, duration: 0.5, animations: {
                    self.pauseImage.isHidden = true
                })
            })
            playerView.pause()
        }
    }

    @objc func playerDidFinishPlaying(note: NSNotification) {
        playerView.seek(to: CMTime.zero)
        playerView.play()
    }
}
