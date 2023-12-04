//
//  ReportViewController.swift
//  Layover
//
//  Created by 황지웅 on 12/4/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol ReportDisplayLogic: AnyObject {

}

final class ReportViewController: BaseViewController, ReportDisplayLogic {

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

}
