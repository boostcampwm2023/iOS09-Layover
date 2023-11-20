//
//  LayoverConstraintWrapper+UIView.swift
//  Layover
//
//  Created by 김인환 on 11/20/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

extension LayoverConstraintWrapper where Base: UIView {

    func makeConstraints(_ closure: (ConstraintMaker) -> Void) {
        base.translatesAutoresizingMaskIntoConstraints = false
        closure(ConstraintMaker(base))
    }
}

final class ConstraintMaker {
    let view: UIView

    init(_ view: UIView) {
        self.view = view
    }

    func topAnchor(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) {
        view.topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }

    func bottomAnchor(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) {
        view.bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }

    func leadingAnchor(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) {
        view.leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }

    func trailingAnchor(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) {
        view.trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }

    func widthAnchor(equalToConstant constant: CGFloat) {
        view.widthAnchor.constraint(equalToConstant: constant).isActive = true
    }

    func widthAnchor(equalTo anchor: NSLayoutDimension, multiplier: CGFloat = 1.0) {
        view.widthAnchor.constraint(equalTo: anchor, multiplier: multiplier).isActive = true
    }

    func heightAnchor(equalToConstant constant: CGFloat) {
        view.heightAnchor.constraint(equalToConstant: constant).isActive = true
    }

    func heightAnchor(equalTo anchor: NSLayoutDimension, multiplier: CGFloat = 1.0) {
        view.heightAnchor.constraint(equalTo: anchor, multiplier: multiplier).isActive = true
    }

    func verticalAnchor(equalTo relativeView: UIView) {
        topAnchor(equalTo: relativeView.topAnchor)
        bottomAnchor(equalTo: relativeView.bottomAnchor)
    }

    func horizontalAnchor(equalTo relativeView: UIView) {
        leadingAnchor(equalTo: relativeView.leadingAnchor)
        trailingAnchor(equalTo: relativeView.trailingAnchor)
    }

    func equalToSuperView() {
        guard let superview = view.superview else { return }
        verticalAnchor(equalTo: superview)
        horizontalAnchor(equalTo: superview)
    }
}
