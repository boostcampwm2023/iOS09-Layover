//
//  LODescriptionView.swift
//  Layover
//
//  Created by 황지웅 on 11/15/23.
//

import UIKit

final class LODescriptionView: UIView {
    static let descriptionWidth: CGFloat = 104
    static let descriptionHeight: CGFloat = 63

    // MARK: - View isTouched State

    enum State {
        case show
        case hidden
    }

    // MARK: - Properties

    private (set) var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 1
        label.font = .loFont(type: .body1)
        label.textColor = .layoverWhite
        label.text = "제목 테스트"
        return label
    }()
    private (set) var descriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .layoverWhite
        label.font = .loFont(type: .body2)
        label.numberOfLines = 0
        return label
    }()

    private var descrioptionText: String = ""
    var state: State = .hidden

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }

    // MARK: Method

    private func setupConstraints() {
        descriptionLabel.textColor = .layoverWhite
        descriptionLabel.font = .loFont(type: .body2)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviews(descriptionLabel, titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }

    func setText(_ content: String) {
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: content)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        descriptionLabel.attributedText = attrString
    }

    func checkLabelOverflow() -> Bool {
        let originViewSize: CGSize = CGSize(width: LODescriptionView.descriptionWidth, height: LODescriptionView.descriptionHeight)
        let currentSize: CGSize = descriptionLabel.intrinsicContentSize
        return currentSize.height > originViewSize.height || currentSize.width > originViewSize.width
    }
}
