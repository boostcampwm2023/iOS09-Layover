//
//  LOSlider.swift
//  Layover
//
//  Created by 황지웅 on 11/15/23.
//

import UIKit

final class LOSlider: UISlider {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        setThumbImage(UIImage.loNormalThumb, for: .normal)
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        setThumbImage(UIImage.loSelectedThumb, for: .normal)
    }

    private func setUI() {
        self.minimumTrackTintColor = .primaryPurple
        setThumbImage(UIImage.loNormalThumb, for: .normal)
    }
}
