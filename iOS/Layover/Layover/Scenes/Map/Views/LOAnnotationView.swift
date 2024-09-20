//
//  LOAnnotationView.swift
//  Layover
//
//  Created by kong on 2023/11/26.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import MapKit
import UIKit

import LOImageCacher

final class LOAnnotationView: MKAnnotationView {

    // MARK: - Layout Constants

    enum Constants {
        static let markerWidth: CGFloat = 43
        static let markerHeight: CGFloat = 53
        static let thumbnailImageViewSize: CGFloat = markerWidth - inset * 2
        static let inset: CGFloat = 4
    }

    // MARK: - UI Components

    private let markerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .mapPin)
        return imageView
    }()

    private let thumbnailImageView: UIImageView = {
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
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bounds.size = markerImageView.bounds.size
    }

    // MARK: - Methods

    func setThumnailImage(with url: URL?) {
        if let url {
            thumbnailImageView.lo.setImage(with: url)
        } else {
            thumbnailImageView.image = .profile
        }
    }

    private func render() {
        thumbnailImageView.layer.cornerRadius = Constants.thumbnailImageViewSize / 2
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.borderWidth = 1
        thumbnailImageView.layer.borderColor = UIColor.grey300.cgColor
    }

    private func setConstraints() {
        addSubviews(markerImageView, thumbnailImageView)
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            markerImageView.widthAnchor.constraint(equalToConstant: Constants.markerWidth),
            markerImageView.heightAnchor.constraint(equalToConstant: Constants.markerHeight),
            thumbnailImageView.topAnchor.constraint(equalTo: markerImageView.topAnchor, constant: Constants.inset),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: Constants.thumbnailImageViewSize),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: Constants.thumbnailImageViewSize),
            thumbnailImageView.centerXAnchor.constraint(equalTo: markerImageView.centerXAnchor)
        ])

    }
}
