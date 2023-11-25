//
//  LOAnnotationView.swift
//  Layover
//
//  Created by kong on 2023/11/26.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit
import MapKit

final class LOAnnotationView: MKAnnotationView {
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

    override func prepareForDisplay() {
        super.prepareForDisplay()
        setThumnailImage()
    }

    func setThumnailImage() {
        self.thumnailImageView.image = .checkmark
    }

    private func render() {
        thumnailImageView.layer.cornerRadius = 19
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
            markerImageView.widthAnchor.constraint(equalToConstant: 44),
            markerImageView.heightAnchor.constraint(equalToConstant: 52),
            thumnailImageView.topAnchor.constraint(equalTo: markerImageView.topAnchor, constant: 3),
            thumnailImageView.heightAnchor.constraint(equalToConstant: 44-8),
            thumnailImageView.leadingAnchor.constraint(equalTo: markerImageView.leadingAnchor, constant: 3),
            thumnailImageView.trailingAnchor.constraint(equalTo: markerImageView.trailingAnchor, constant: -3),
        ])

    }
}
