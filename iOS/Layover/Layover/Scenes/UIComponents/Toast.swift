//
//  Toast.swift
//  Layover
//
//  Created by 황지웅 on 11/28/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class Toast {
    private let toastMessageLabel: UILabel = {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 192, height: 46))
        // Font 추천 바람
        label.font = .loFont(type: .body2Semibold)
        label.layer.cornerRadius = 8
        label.backgroundColor = .background
        label.textColor = .layoverWhite
        label.alpha = 0.0
        label.textAlignment = .center
        return label
    }()

    static let shared = Toast()

    private init() {
        let scenes: Set<UIScene> = UIApplication.shared.connectedScenes
        let windowScene: UIWindowScene? = scenes.first as? UIWindowScene
        let window: UIWindow? = windowScene?.windows.first
        window?.addSubview(toastMessageLabel)
        guard let windowWidth: CGFloat = windowScene?.screen.bounds.width else {
            return
        }
        guard let windowHeight: CGFloat = windowScene?.screen.bounds.height else {
            return
        }
        toastMessageLabel.frame = CGRect(
            x: (windowWidth - 192) / 2,
            y: (windowHeight - 46) / 2,
            width: 192,
            height: 46)
    }

    func showToast(message: String) {
        toastMessageLabel.text = message
        UIView.animate(withDuration: 1.0, delay: 0.1, animations: {
            self.toastMessageLabel.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, delay: 0.1, animations: {
                self.toastMessageLabel.alpha = 0.0
            })
        })
    }
}
