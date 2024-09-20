//
//  UIFont+.swift
//  Layover
//
//  Created by kong on 2023/11/14.
//

import UIKit

enum TextStyles {
    case header1
    case header2
    case subtitle
    case caption
    case body1
    case body2
    case body2Semibold
    case body2Bold
    case body3
    case logoTitle
}

enum LOWeight: String {
    case bold = "Bold"
    case semibold = "SemiBold"
    case regular = "Regular"
}

enum FontType: String {
    case pretendard = "Pretendard"
    case dashboard = "Dashboard"
}

extension UIFont {
    static func loFont(type: TextStyles) -> UIFont {
        switch type {
        case .header1:
            return .loFont(ofSize: 28, weight: .bold)
        case .header2:
            return .loFont(ofSize: 24, weight: .bold)
        case .subtitle:
            return .loFont(ofSize: 20, weight: .semibold)
        case .caption:
            return .loFont(ofSize: 12, weight: .regular)
        case .body1:
            return .loFont(ofSize: 18, weight: .regular)
        case .body2:
            return .loFont(ofSize: 16, weight: .regular)
        case .body2Semibold:
            return .loFont(ofSize: 16, weight: .semibold)
        case .body2Bold:
            return .loFont(ofSize: 16, weight: .bold)
        case .body3:
            return .loFont(ofSize: 14, weight: .regular)
        case .logoTitle:
            return .loFont(ofSize: 32, weight: .regular, type: .dashboard)
        }
    }

    static func loFont(ofSize fontSize: CGFloat,
                       weight: LOWeight = .regular,
                       type: FontType = .pretendard) -> UIFont {
        return UIFont(name: "\(type)-\(weight)", size: fontSize)!
    }
}
