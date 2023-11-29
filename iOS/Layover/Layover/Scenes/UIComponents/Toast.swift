//
//  Toast.swift
//  Layover
//
//  Created by 황지웅 on 11/28/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class Toast {
    static let shared = Toast()

    private init() {}

    func showToast(message: String) {
        let scenes: Set<UIScene> = UIApplication.shared.connectedScenes
        let windowScene: UIWindowScene? = scenes.first as? UIWindowScene
        let window: UIWindow? = windowScene?.windows.first
        let toastLabel: UILabel = UILabel()
        guard let windowWidth: CGFloat = windowScene?.screen.bounds.width else { return }
        guard let windowHeight: CGFloat = windowScene?.screen.bounds.height else { return }
        toastLabel.backgroundColor = .background
        toastLabel.textColor = .layoverWhite
        toastLabel.textAlignment = .center
        toastLabel.font = .loFont(type: .body2)
        toastLabel.text = message
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 1
        toastLabel.layer.opacity = 0.8
        let size: CGSize = toastLabel.intrinsicContentSize
        toastLabel.frame = CGRect(
            x: (windowWidth - size.width) / 2,
            y: (windowHeight - size.height) / 2,
            width: size.width,
            height: size.height)

        window?.addSubview(toastLabel)

        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
