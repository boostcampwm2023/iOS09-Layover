//
//  LoopingPlayerView.swift
//  Layover
//
//  Created by 김인환 on 11/20/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit
import AVFoundation

final class LoopingPlayerView: UIView {

    // MARK: - Properties

    override static var layerClass: AnyClass { AVPlayerLayer.self }

    private(set) var player: AVQueuePlayer? {
        get { playerLayer?.player as? AVQueuePlayer }
        set { playerLayer?.player = newValue }
    }

    private var looper: AVPlayerLooper?

    private var playerLayer: AVPlayerLayer? { layer as? AVPlayerLayer }

    // MARK: - View Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }

    // MARK: - Methods

    func prepareVideo(with url: URL, timeRange: CMTimeRange) {
        let playerItem = AVPlayerItem(url: url)
        let player = AVQueuePlayer(playerItem: playerItem)
        looper = AVPlayerLooper(player: player, templateItem: playerItem, timeRange: timeRange)
        self.player = player
    }

    func disable() {
        player?.pause()
        player = nil
        looper = nil
    }

    func play() {
        player?.play()
    }

    func pause() {
        player?.pause()
    }
}

#Preview {
    let view = LoopingPlayerView()
    view.prepareVideo(with: URL(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")!, 
                      timeRange: .init(start: .zero,
                                       end: .init(seconds: 3.0, preferredTimescale: CMTimeScale(1.0))))
    view.play()
    view.player?.isMuted = true
    return view
}
