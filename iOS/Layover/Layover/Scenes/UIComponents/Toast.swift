//
//  Toast.swift
//  Layover
//
//  Created by 황지웅 on 11/28/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class ToastLabel: UILabel {
    private let topInset: CGFloat = 14
    private let bottomInset: CGFloat = 14
    private let leftInset: CGFloat = 25
    private let rightInset: CGFloat = 25

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet { preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset) }
    }

}

final class Toast {
    static let shared = Toast()

    private init() {}

    func showToast(message: String) {
        let scenes: Set<UIScene> = UIApplication.shared.connectedScenes
        let windowScene: UIWindowScene? = scenes.first as? UIWindowScene
        guard let window: UIWindow = windowScene?.windows.first else { return }
        let toastLabel: ToastLabel = ToastLabel()
        toastLabel.backgroundColor = .background
        toastLabel.textColor = .layoverWhite
        toastLabel.textAlignment = .center
        toastLabel.font = .loFont(type: .body2)
        toastLabel.text = message
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 1
        toastLabel.layer.opacity = 0.8
        toastLabel.frame.size = toastLabel.intrinsicContentSize
        window.addSubview(toastLabel)
        toastLabel.center = window.center
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
