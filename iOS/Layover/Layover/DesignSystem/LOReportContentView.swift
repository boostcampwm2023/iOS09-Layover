//
//  LOReportContentView.swift
//  Layover
//
//  Created by 황지웅 on 12/4/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class LOReportContentView: UIView {

    // MARK: - UI Components

    var index: Int = 0
    
    private let whiteCircle: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .layoverWhite
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }()

    private let radioView: UIView = {
        let view: UIView = UIView()
        view.layer.borderColor = UIColor.grey100.cgColor
        view.layer.borderWidth = 0.1
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.isUserInteractionEnabled = false
        return view
    }()

    let contentLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "스팸 / 홍보 도배글이에요"
        label.font = .loFont(type: .body2)
        label.textAlignment = .left
        label.textColor = .layoverWhite
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setConstraints()
    }

    func onRadio() {
        whiteCircle.isHidden = false
        radioView.backgroundColor = .primaryPurple
    }

    func offRadio() {
        whiteCircle.isHidden = true
        radioView.backgroundColor = .clear
    }

    func setText(_ content: String) {
        contentLabel.text = content
    }

    // MARK: - UI Methods

    private func setConstraints() {
        radioView.addSubview(whiteCircle)
        whiteCircle.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(radioView, contentLabel)
        subviews.forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            whiteCircle.centerXAnchor.constraint(equalTo: radioView.centerXAnchor),
            whiteCircle.centerYAnchor.constraint(equalTo: radioView.centerYAnchor),
            whiteCircle.widthAnchor.constraint(equalToConstant: 8),
            whiteCircle.heightAnchor.constraint(equalToConstant: 8),
            radioView.widthAnchor.constraint(equalToConstant: 20),
            radioView.heightAnchor.constraint(equalToConstant: 20),
            radioView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            radioView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            radioView.trailingAnchor.constraint(equalTo: contentLabel.leadingAnchor, constant: -12),
            contentLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
