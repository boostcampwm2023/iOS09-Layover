//
//  PlaybackViewController.swift
//  Layover
//
//  Created by 황지웅 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit
#Preview {
    PlaybackViewController()
}
protocol PlaybackDisplayLogic: AnyObject {
    func displayFetchFromLocalDataStore(with viewModel: PlaybackModels.FetchFromLocalDataStore.ViewModel)
    func displayFetchFromRemoteDataStore(with viewModel: PlaybackModels.FetchFromRemoteDataStore.ViewModel)
    func displayTrackAnalytics(with viewModel: PlaybackModels.TrackAnalytics.ViewModel)
    func displayPerformPlayback(with viewModel: PlaybackModels.PerformPlayback.ViewModel)
}

final class PlaybackViewController: UIViewController, PlaybackDisplayLogic {

    // MARK: = UI Components

    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 1
        label.font = .loFont(type: .subtitle)
        label.textColor = .layoverWhite
        label.text = "테스트"
        return label
    }()

    private let descriptionView: LODescriptionView = {
        let descriptionView: LODescriptionView = LODescriptionView()
        descriptionView.setText("테스트22테스트22테스트22테스트22테스트22테스트22테스트22테스트22테스트22테스트22테스트22테스트22테스트22테스트22테스트22테스트22")
        descriptionView.clipsToBounds = true
        return descriptionView
    }()

    private var descriptionViewHeight: NSLayoutConstraint! = nil
    private var descriptionViewBottom: NSLayoutConstraint! = nil

    private let gradientLayer: CAGradientLayer = {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: LODescriptionView.descriptionWidth, height: LODescriptionView.descriptionHeight)
        let colors: [CGColor] = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        return gradientLayer
    }()

    private let tagStackView: LOTagStackView = {
        let tagStackView: LOTagStackView = LOTagStackView()
        return tagStackView
    }()

    private let profileButton: UIButton = {
        let button: UIButton = UIButton()
        button.layer.cornerRadius = 19
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.layoverWhite.cgColor
//        button.setImage(UIImage(systemName: "cancel"), for: .normal)
        button.backgroundColor = .layoverWhite
        return button
    }()

    private let profileLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .loFont(type: .body2Bold)
        label.textColor = UIColor.layoverWhite
        label.text = "@테스트"
        return label
    }()

    private let locationLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .loFont(type: .body2)
        label.textColor = UIColor.layoverWhite
        label.text = "테스트"
        return label
    }()

    private let videoSlider: LOSlider = LOSlider()

    private let videoView: UIView = UIView()

    private var isIncreaseLabel: Bool = false
    // MARK: - Properties

    typealias Models = PlaybackModels
    var router: (NSObjectProtocol & PlaybackRoutingLogic & PlaybackDataPassing)?
    var interactor: PlaybackBusinessLogic?

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
        let viewController = self
        let interactor = PlaybackInteractor()
        let presenter = PlaybackPresenter()
        let router = PlaybackRouter()

        viewController.router = router
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupFetchFromLocalDataStore()
        setUI()
        let labelTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(descriptionLabelDidTap(_:)))
        descriptionView.descriptionLabel.isUserInteractionEnabled = true
        descriptionView.descriptionLabel.addGestureRecognizer(labelTapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchFromRemoteDataStore()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackScreenViewAnalytics()
        registerNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterNotifications()
    }

    // MARK: - UI + Layout

    private func setUI() {
        [titleLabel, descriptionView, tagStackView, profileButton, profileLabel, locationLabel, videoSlider].forEach { subView in
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionView.topAnchor, constant: -5),

            descriptionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionView.bottomAnchor.constraint(equalTo: tagStackView.topAnchor, constant: -11),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionView.widthAnchor.constraint(equalToConstant: LODescriptionView.descriptionWidth),

            tagStackView.bottomAnchor.constraint(equalTo: profileButton.topAnchor, constant: -20),
            tagStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tagStackView.heightAnchor.constraint(equalToConstant: 25),

            profileButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            profileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileButton.widthAnchor.constraint(equalToConstant: 38),
            profileButton.heightAnchor.constraint(equalToConstant: 38),

            profileLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor),
            profileLabel.leadingAnchor.constraint(equalTo: profileButton.trailingAnchor, constant: 14),

            locationLabel.leadingAnchor.constraint(equalTo: profileButton.trailingAnchor, constant: 14),
            locationLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -19),

            videoSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoSlider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        descriptionViewHeight = descriptionView.heightAnchor.constraint(equalToConstant: LODescriptionView.descriptionHeight)
        descriptionViewHeight.isActive = true

        if descriptionView.checkLabelOverflow() {
            descriptionView.layer.addSublayer(gradientLayer)
        }
    }
    // MARK: - Notifications

    func registerNotifications() {
        let selector = #selector(trackScreenViewAnalytics)
        let notification = UIApplication.didBecomeActiveNotification
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }

    func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Use Case - Fetch From Local DataStore

    @IBOutlet var exampleLocalLabel: UILabel! = UILabel()
    func setupFetchFromLocalDataStore() {
        let request = Models.FetchFromLocalDataStore.Request()
        interactor?.fetchFromLocalDataStore(with: request)
    }

    func displayFetchFromLocalDataStore(with viewModel: PlaybackModels.FetchFromLocalDataStore.ViewModel) {
        exampleLocalLabel.text = viewModel.exampleTranslation
    }

    // MARK: - Use Case - Fetch From Remote DataStore

    @IBOutlet var exampleRemoteLabel: UILabel! = UILabel()
    func setupFetchFromRemoteDataStore() {
        let request = Models.FetchFromRemoteDataStore.Request()
        interactor?.fetchFromRemoteDataStore(with: request)
    }

    func displayFetchFromRemoteDataStore(with viewModel: PlaybackModels.FetchFromRemoteDataStore.ViewModel) {
        exampleRemoteLabel.text = viewModel.exampleVariable
    }

    // MARK: - Use Case - Track Analytics

    @objc
    func trackScreenViewAnalytics() {
        trackAnalytics(event: .screenView)
    }

    func trackAnalytics(event: PlaybackModels.AnalyticsEvents) {
        let request = Models.TrackAnalytics.Request(event: event)
        interactor?.trackAnalytics(with: request)
    }

    func displayTrackAnalytics(with viewModel: PlaybackModels.TrackAnalytics.ViewModel) {
        // do something after tracking analytics (if needed)
    }

    // MARK: - Use Case - Playback

    func performPlayback(_ sender: Any) {
        let request = Models.PerformPlayback.Request(exampleVariable: exampleLocalLabel.text)
        interactor?.performPlayback(with: request)
    }

    func displayPerformPlayback(with viewModel: PlaybackModels.PerformPlayback.ViewModel) {
        // handle error and ui element error states
        // based on error type
        if let error = viewModel.error {
            switch error.type {
            case .emptyExampleVariable:
                exampleLocalLabel.text = error.message

            case .networkError:
                exampleLocalLabel.text = error.message
            }

            return
        }

        // handle ui element success state and
        // route to next screen
        router?.routeToNext()
    }

    // MARK: - Custom Method

    @objc private func descriptionLabelDidTap(_ sender: UITapGestureRecognizer) {
        if let descriptionLabel = sender.view {
            if self.descriptionView.clipsToBounds {
                UIView.animate(withDuration: 0.3, animations: {
                    self.descriptionView.transform = CGAffineTransform(translationX: 0, y: -(descriptionLabel.frame.height - LODescriptionView.descriptionHeight))
                    self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -(descriptionLabel.frame.height - LODescriptionView.descriptionHeight))
                    self.gradientLayer.isHidden = true
                }, completion: { _ in
                    self.descriptionView.clipsToBounds = false
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.titleLabel.transform = .identity
                    self.descriptionView.transform = .identity
                    self.gradientLayer.isHidden = false
                    self.descriptionView.clipsToBounds = true
                })
            }
        }
    }
}
