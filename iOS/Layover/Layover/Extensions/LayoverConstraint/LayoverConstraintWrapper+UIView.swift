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

    // MARK: Properties

    private let view: UIView

    var edges: ConstraintEdges {
        ConstraintEdges(view)
    }

    var top: ConstraintEdges {
        ConstraintEdges(view).top
    }

    var bottom: ConstraintEdges {
        ConstraintEdges(view).bottom
    }

    var leading: ConstraintEdges {
        ConstraintEdges(view).leading
    }

    var trailing: ConstraintEdges {
        ConstraintEdges(view).trailing
    }

    var width: ConstraintEdges {
        ConstraintEdges(view).width
    }

    var height: ConstraintEdges {
        ConstraintEdges(view).height
    }

    var centerX: ConstraintEdges {
        ConstraintEdges(view).centerX
    }

    var centerY: ConstraintEdges {
        ConstraintEdges(view).centerY
    }

    var center: ConstraintEdges {
        ConstraintEdges(view).center
    }

    // MARK: Initializer

    init(_ view: UIView) {
        self.view = view
    }
}

final class ConstraintEdges {

    // MARK: Properties

    private let view: UIView

    private var topAnchor: NSLayoutYAxisAnchor?
    private var leadingAnchor: NSLayoutXAxisAnchor?
    private var trailingAnchor: NSLayoutXAxisAnchor?
    private var bottomAnchor: NSLayoutYAxisAnchor?

    private var widthAnchor: NSLayoutDimension?
    private var heightAnchor: NSLayoutDimension?

    private var centerXAnchor: NSLayoutXAxisAnchor?
    private var centerYAnchor: NSLayoutYAxisAnchor?

    // MARK: Builder Pattern Properties

    var top: ConstraintEdges {
        topAnchor = view.topAnchor
        return self
    }

    var leading: ConstraintEdges {
        leadingAnchor = view.leadingAnchor
        return self
    }

    var trailing: ConstraintEdges {
        trailingAnchor = view.trailingAnchor
        return self
    }

    var bottom: ConstraintEdges {
        bottomAnchor = view.bottomAnchor
        return self
    }

    var width: ConstraintEdges {
        widthAnchor = view.widthAnchor
        return self
    }

    var height: ConstraintEdges {
        heightAnchor = view.heightAnchor
        return self
    }

    var centerX: ConstraintEdges {
        centerXAnchor = view.centerXAnchor
        return self
    }

    var centerY: ConstraintEdges {
        centerYAnchor = view.centerYAnchor
        return self
    }

    var center: ConstraintEdges {
        centerXAnchor = view.centerXAnchor
        centerYAnchor = view.centerYAnchor
        return self
    }

    // MARK: Intializer

    init(_ view: UIView) {
        self.view = view
    }

    // MARK: Methods

    func equalToSuperView() {
        guard let superView = view.superview else { return }

        NSLayoutConstraint.activate([
            topAnchor?.constraint(equalTo: superView.topAnchor),
            leadingAnchor?.constraint(equalTo: superView.leadingAnchor),
            trailingAnchor?.constraint(equalTo: superView.trailingAnchor),
            bottomAnchor?.constraint(equalTo: superView.bottomAnchor)
        ].compactMap { $0 })
    }
}
