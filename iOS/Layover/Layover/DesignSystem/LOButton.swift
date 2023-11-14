//
//  LOButton.swift
//  Layover
//
//  Created by kong on 2023/11/14.
//

import UIKit

final class LOButton: UIButton {

    // MARK: - Button Type

    enum Style {
        case basic
    }

    // MARK: - Properties

    private let style: Style

    private var buttonBackgroundColor: UIColor {
        switch style {
        case .basic:
            return isEnabled ? .primaryPurple : .darkGrey
        }
    }

    private var buttonTitleColor: UIColor {
        switch style {
        case .basic:
            return isEnabled ? .white : .grey500
        }
    }

    override var isEnabled: Bool {
        didSet {
            setColors()
        }
    }

    // MARK: - Initializer

    init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        setInitialStateUI()
    }

    required init?(coder: NSCoder) {
        self.style = .basic
        super.init(coder: coder)
        setInitialStateUI()
    }

    // MARK: - Custom Method

    private func setInitialStateUI() {
        layer.cornerRadius = 8
        titleLabel?.font = .loFont(type: .body2Semibold)
        setColors()
    }

    private func setColors() {
        setTitleColor(buttonTitleColor, for: state)
        backgroundColor = buttonBackgroundColor
    }

}
