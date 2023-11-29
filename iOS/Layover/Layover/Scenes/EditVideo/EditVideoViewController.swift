//
//  EditVideoViewController.swift
//  Layover
//
//  Created by kong on 2023/11/29.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditVideoDisplayLogic: AnyObject {
    func displayVideo()
}

final class EditVideoViewController: BaseViewController {

    // MARK: - UI Components

    private let loopingPlayerView: LoopingPlayerView = {
        let playerView = LoopingPlayerView()
        return playerView
    }()

    private let soundButton: LOCircleButton = {
        let button = LOCircleButton(style: .sound, diameter: 52)
        return button
    }()

    private let cutButton: LOCircleButton = {
        let button = LOCircleButton(style: .scissors, diameter: 52)
        return button
    }()

    private let nextButton: LOButton = {
        let button = LOButton(style: .basic)
        button.setTitle("다음", for: .normal)
        return button
    }()

    // MARK: - Properties

    typealias Models = EditVideoModels
    var router: (NSObjectProtocol & EditVideoRoutingLogic & EditVideoDataPassing)?
    var interactor: EditVideoBusinessLogic?

    // MARK: - Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        EditVideoConfigurator.shared.configure(self)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setConstraints() {
        view.addSubviews(loopingPlayerView, soundButton, cutButton, nextButton)
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            loopingPlayerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loopingPlayerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loopingPlayerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loopingPlayerView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -19),

            soundButton.trailingAnchor.constraint(equalTo: cutButton.leadingAnchor, constant: -9),
            soundButton.bottomAnchor.constraint(equalTo: loopingPlayerView.bottomAnchor, constant: -15),

            cutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            cutButton.bottomAnchor.constraint(equalTo: loopingPlayerView.bottomAnchor, constant: -15),

            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            nextButton.widthAnchor.constraint(equalToConstant: 117),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -13)
        ])
    }

}

extension EditVideoViewController: EditVideoDisplayLogic {

    func displayVideo() {

    }

}

#Preview {
    EditVideoViewController()
}
