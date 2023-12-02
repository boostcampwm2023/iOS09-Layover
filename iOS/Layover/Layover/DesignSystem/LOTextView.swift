//
//  LOTextView.swift
//  Layover
//
//  Created by kong on 2023/12/01.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class LOTextView: UITextView {

    private let minimumHeight: CGFloat

    init(minimumHeight: CGFloat) {
        self.minimumHeight = minimumHeight
        super.init(frame: .zero, textContainer: nil)
        delegate = self
        setUI()
    }

    required init?(coder: NSCoder) {
        self.minimumHeight = 44
        super.init(coder: coder)
        delegate = self
        setUI()
    }

    private func setUI() {
        backgroundColor = .clear
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.grey200.cgColor
        font = .loFont(type: .body2)
        heightAnchor.constraint(greaterThanOrEqualToConstant: minimumHeight).isActive = true
        textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        textContainer.lineFragmentPadding = .zero
    }

    private func setFocusStateColors(isFocused: Bool) {
        let color = isFocused ? UIColor.grey200 : UIColor.grey500
        layer.borderColor = color.cgColor
        textColor = color
    }

}

extension LOTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: frame.width, height: .greatestFiniteMagnitude)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if estimatedSize.height > minimumHeight && constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        setFocusStateColors(isFocused: true)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        layer.borderColor = UIColor.grey500.cgColor
        setFocusStateColors(isFocused: false)
    }
}
