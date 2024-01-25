//
//  LOTextLabel.swift
//  Layover
//
//  Created by 황지웅 on 1/25/24.
//  Copyright © 2024 CodeBomber. All rights reserved.
//

import UIKit

final class LOTextLabel: UILabel {

    private var padding = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
        setUI()
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }

    private func setUI() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.grey500.cgColor
        backgroundColor = UIColor.clear
    }
}
