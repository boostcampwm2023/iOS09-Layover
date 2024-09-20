//
//  ReportViewController.swift
//  Layover
//
//  Created by 황지웅 on 12/4/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol ReportViewControllerDelegate: AnyObject {
    func reportPlaybackVideo(reportContent: String)
    func dismissReportView()
}

protocol ReportDisplayLogic: AnyObject {
    func displayReportResult(viewModel: ReportModels.ReportPlaybackVideo.ViewModel)
}

final class ReportViewController: BaseViewController {

    // MARK: - UI Components

    private let popUpView: LOPopUpView = {
        let view: LOPopUpView = LOPopUpView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .darkGrey
        return view
    }()

    private let backgroundView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()

    // MARK: - Properties

    typealias Models = ReportModels
    var router: (NSObjectProtocol & ReportRoutingLogic & ReportDataPassing)?
    var interactor: ReportBusinessLogic?

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
        ReportConfigurator.shared.configure(self)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setUI() {
        super.setUI()
        popUpView.delegate = self
    }

    override func setConstraints() {
        super.setConstraints()
        view.addSubviews(backgroundView, popUpView)
        view.subviews.forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            popUpView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popUpView.widthAnchor.constraint(equalToConstant: 350),
            popUpView.heightAnchor.constraint(equalToConstant: 450)
        ])
    }

    @objc private func cancelButtonDidTap() {
        dismiss(animated: true)
    }
}

extension ReportViewController: ReportViewControllerDelegate {
    func reportPlaybackVideo(reportContent: String) {
        let request: Models.ReportPlaybackVideo.Request = Models.ReportPlaybackVideo.Request(reportContent: reportContent)
        interactor?.reportPlaybackVideo(with: request)
    }

    func dismissReportView() {
        dismiss(animated: false)
    }
}

extension ReportViewController: ReportDisplayLogic {
    func displayReportResult(viewModel: ReportModels.ReportPlaybackVideo.ViewModel) {
        dismiss(animated: false, completion: {
            Toast.shared.showToast(message: viewModel.reportMessage.description)
        })
    }
}

//#Preview {
//    ReportViewController()
//}
