//
//  LOSlider.swift
//  Layover
//
//  Created by 황지웅 on 11/15/23.
//

import UIKit

final class LOSlider: UISlider {
    private let normalThumbImage: String = "LONormalThumb"
    private let selectedThumbImage: String = "LOSelectedThumb"

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.minimumTrackTintColor = .primaryPurple
        setThumbImage(UIImage(named: normalThumbImage), for: .normal)
        self.minimumValue = 1
        self.maximumValue = 100
        self.value = 50
    
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        setThumbImage(UIImage(named: selectedThumbImage), for: .normal)
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        setThumbImage(UIImage(named: normalThumbImage), for: .normal)
    }
}
