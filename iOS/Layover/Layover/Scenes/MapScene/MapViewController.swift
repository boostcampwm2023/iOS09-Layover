//
//  MapViewController.swift
//  Layover
//
//  Created by kong on 2023/11/15.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import MapKit
import UIKit

protocol MapDisplayLogic: AnyObject {

}

final class MapViewController: BaseViewController {

    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        return mapView
    }()

    private let currentLocationButton: LOCircleButton = {
        let button = LOCircleButton(style: .locate, diameter: 52)
        return button
    }()

    private let uploadButton: LOCircleButton = {
        let button = LOCircleButton(style: .add, diameter: 52)
        return button
    }()

    private let searchButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.loFont(type: .body3)
        configuration.attributedTitle = AttributedString("현재 위치에서 검색하기", attributes: titleContainer)
        configuration.image = UIImage(resource: .retry)
        configuration.imagePadding = 5
        configuration.cornerStyle = .capsule
        configuration.background.backgroundColor = .darkGrey
        configuration.background.strokeColor = .grey500
        configuration.background.strokeWidth = 1
        let button = UIButton(configuration: configuration)
        return button
    }()

    // MARK: - UI Components

    var interactor: MapBusinessLogic?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        MapConfigurator.shared.configure(self)
    }

    // MARK: - UI + Layout

    override func setUI() {

    }

    override func setConstraints() {
        view.addSubviews(mapView, searchButton, currentLocationButton, uploadButton)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 42),

            uploadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            uploadButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            currentLocationButton.bottomAnchor.constraint(equalTo: uploadButton.topAnchor, constant: -10),
            currentLocationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

extension MapViewController: MapDisplayLogic {

}
