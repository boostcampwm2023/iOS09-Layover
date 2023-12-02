//
//  LOCircleButton.swift
//  Layover
//
//  Created by 김인환 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class LOCircleButton: UIButton {

    // MARK: Button Type

    enum Style {
        case add
        case smallAdd
        case locate
        case photo
        case sound
        case scissors
    }

    // MARK: Properties

    private(set) var diameter: CGFloat

    var style: Style {
        didSet {
            setBackgroundColor(by: style)
            setImage(by: style)
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: diameter, height: diameter)
    }

    // MARK: Initializer

    init(style: Style, diameter: CGFloat) {
        self.style = style
        self.diameter = diameter
        super.init(frame: .zero)
        setBorder()
        setBackgroundColor(by: style)
        setImage(by: style)
    }

    required init?(coder: NSCoder) {
        self.style = .add
        self.diameter = 52
        super.init(coder: coder)
        setBorder()
        setBackgroundColor(by: style)
        setImage(by: style)
    }

    // MARK: View Life Cycle

    override func layoutSubviews() {
        makeRounded(to: diameter)
        super.layoutSubviews()
    }

    // MARK: Methods

    private func setBorder() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.grey500.cgColor
    }

    private func setBackgroundColor(by style: Style) {
        switch style {
        case .add, .smallAdd:
            backgroundColor = .primaryPurple
        default:
            backgroundColor = .darkGrey
        }
    }

    private func setImage(by style: Style) {
        switch style {
        case .add:
            setImage(.plus, for: .normal)
        case .smallAdd:
            setImage(.smallPlus, for: .normal)
        case .locate:
            setImage(.myLocation, for: .normal)
        case .photo:
            setImage(.photo, for: .normal)
        case .sound:
            setImage(.volume, for: .normal)
            setImage(.mute, for: .selected)
        case .scissors:
            setImage(.scissors, for: .normal)
        }
    }

    func makeRounded(to diameter: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = diameter / 2
        self.diameter = diameter
    }
}
