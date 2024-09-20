//
//  LOTextField.swift
//  Layover
//
//  Created by kong on 2023/11/14.
//

import UIKit

final class LOTextField: UITextField {

    private let textCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .loFont(type: .caption)
        label.textColor = .grey500
        return label
    }()

    override var placeholder: String? {
        didSet {
            setPlaceholderColor()
        }
    }

    init() {
        super.init(frame: .zero)
        setUI()
        setConstraints()
        addTarget()
        delegate = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
        setConstraints()
        addTarget()
        delegate = self
    }

    private func setUI() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.grey500.cgColor
        backgroundColor = UIColor.clear
        setPadding()
    }

    private func setConstraints() {
        addSubview(textCountLabel)
        textCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }

    private func addTarget() {
        self.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
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

    @objc private func textDidChange() {
        textCountLabel.text = "\(text?.count ?? 0)"
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
