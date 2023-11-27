//
//  LOAnnotationView.swift
//  Layover
//
//  Created by kong on 2023/11/26.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import MapKit
import UIKit

final class LOAnnotationView: MKAnnotationView {

    // MARK: - Layout Constants

    enum Constants {
        static let markerWidth: CGFloat = 43
        static let markerHeight: CGFloat = 53
        static let thumnailImageViewSize: CGFloat = markerWidth - inset * 2
        static let inset: CGFloat = 4
    }

    // MARK: - UI Components

    private let markerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .mapPin)
        return imageView
    }()

    private let thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: - Object Lifecycle

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setConstraints()
        render()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setConstraints()
        render()
    }

    // MARK: - View Lifecycle
    override func prepareForDisplay() {
        super.prepareForDisplay()
        setThumnailImage()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bounds.size = markerImageView.bounds.size
    }

    // MARK: - Methods

    func setThumnailImage() {
        self.thumnailImageView.image = .checkmark
    }

    private func render() {
        thumnailImageView.layer.cornerRadius = Constants.thumnailImageViewSize / 2
        thumnailImageView.clipsToBounds = true
        thumnailImageView.layer.borderWidth = 1
        thumnailImageView.layer.borderColor = UIColor.grey300.cgColor
    }

    private func setConstraints() {
        addSubviews(markerImageView, thumnailImageView)
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            markerImageView.widthAnchor.constraint(equalToConstant: Constants.markerWidth),
            markerImageView.heightAnchor.constraint(equalToConstant: Constants.markerHeight),
            thumnailImageView.topAnchor.constraint(equalTo: markerImageView.topAnchor, constant: Constants.inset),
            thumnailImageView.widthAnchor.constraint(equalToConstant: Constants.thumnailImageViewSize),
            thumnailImageView.heightAnchor.constraint(equalToConstant: Constants.thumnailImageViewSize),
            thumnailImageView.centerXAnchor.constraint(equalTo: markerImageView.centerXAnchor)
        ])

    }
}
