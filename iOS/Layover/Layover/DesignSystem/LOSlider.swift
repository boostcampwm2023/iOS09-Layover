//
//  LOSlider.swift
//  Layover
//
//  Created by 황지웅 on 11/15/23.
//

import UIKit

final class LOSlider: UISlider {
    static let loSliderHeight: CGFloat = 10

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        setThumbImage(UIImage.loSelectedThumb, for: .normal)
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        setThumbImage(UIImage.loNormalThumb, for: .normal)
    }

    private func setUI() {
        self.minimumTrackTintColor = .primaryPurple
        setThumbImage(UIImage.loNormalThumb, for: .normal)
    }
}
