//
//  UIViewController+.swift
//  Layover
//
//  Created by kong on 2023/11/26.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

extension UIViewController {
    var screenSize: CGRect {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return view.window?.windowScene?.screen.bounds ?? CGRect(x: 0, y: 0, width: 320, height: 667)
        }
        return window.screen.bounds
    }
}
