//
//  PlayerView.swift
//  Layover
//
//  Created by 김인환 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit
import AVFoundation

final class PlayerView: UIView {

    // MARK: - Properties

    // Override the property to make AVPlayerLayer the view's backing layer.
    override static var layerClass: AnyClass { AVPlayerLayer.self }

    // The associated player object.
    var player: AVPlayer? {
        get { playerLayer?.player }
        set { playerLayer?.player = newValue }
    }

    private var playerLayer: AVPlayerLayer? { layer as? AVPlayerLayer }

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: View Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }

    // MARK: Methods

    func setVideoFillMode(_ mode: AVLayerVideoGravity) {
        playerLayer?.videoGravity = mode
    }

    func play() {
        playerLayer?.player?.play()
    }

    func pause() {
        playerLayer?.player?.pause()
    }

    func seek(to time: CMTime) {
        playerLayer?.player?.seek(to: time)
    }

    func isPlaying() -> Bool {
        return playerLayer?.player?.rate != 0 && playerLayer?.player?.error == nil
    }
}

#Preview {
    let view = PlayerView()
    view.player = AVPlayer(url: URL(string: "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8")!)
    view.player?.isMuted = true
    view.play()
    return view
}
