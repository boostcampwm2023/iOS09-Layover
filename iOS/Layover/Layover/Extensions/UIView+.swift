//
//  UIView+.swift
//  Layover
//
//  Created by 김인환 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

extension UIView {

    static var identifier: String {
        return String(describing: self)
    }

    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
