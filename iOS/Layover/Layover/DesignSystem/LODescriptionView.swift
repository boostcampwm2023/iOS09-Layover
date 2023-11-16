//
//  LODescriptionView.swift
//  Layover
//
//  Created by 황지웅 on 11/15/23.
//

import UIKit

final class LODescriptionView: UIView {
    static let descriptionWidth: CGFloat = 207
    static let descriptionHeight: CGFloat = 42

    enum State {
        case show
        case hidden
    }

    private var titleLabel: UILabel = UILabel()
    private (set) var descriptionLabel: UILabel = UILabel()
    private var descrioptionText: String = ""
    var newHeight: CGFloat = 0
    var originFrame: CGRect = CGRect()
    var state: State = .hidden

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }

    private func setupConstraints() {
        descriptionLabel.textColor = .layoverWhite
        descriptionLabel.font = .loFont(type: .body2)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(descriptionLabel)
        self.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5)
        ])
    }

    func setText(_ content: String) {
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: content)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        descriptionLabel.attributedText = attrString
    }

    func checkLabelOverflow() -> Bool {
        let originViewSize: CGSize = CGSize(width: LODescriptionView.descriptionWidth, height: LODescriptionView.descriptionWidth)
        let currentSize: CGSize = descriptionLabel.intrinsicContentSize
        return currentSize.height > originViewSize.height || currentSize.width > originViewSize.width
    }
}
