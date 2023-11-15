//
//  LOTextField.swift
//  Layover
//
//  Created by kong on 2023/11/14.
//

import UIKit

final class LOTextField: UITextField {

    override var placeholder: String? {
        didSet {
            setPlaceholderColor()
        }
    }

    init() {
        super.init(frame: .zero)
        setUI()
        delegate = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
        delegate = self
    }

    private func setUI() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.grey500.cgColor
        backgroundColor = UIColor.clear
        setPadding()
    }
    private func setPlaceholderColor() {
        guard let placeholder else { return }
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.grey500])
    }

    private func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
        rightView = paddingView
        rightViewMode = .always
    }

    private func setFocusStateColors(isFocused: Bool) {
        let color = isFocused ? UIColor.grey200 : UIColor.grey500
        layer.borderColor = color.cgColor
        textColor = color
    }

}

extension LOTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setFocusStateColors(isFocused: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        layer.borderColor = UIColor.grey500.cgColor
        setFocusStateColors(isFocused: false)
    }
}
