//
//  MainTabBarViewController.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import UIKit

final class MainTabBarViewController: UITabBarController {

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
        MainTabBarConfigurator.shared.configure(self)
    }

    // MARK: ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    // MARK: - UI

    private func setUI() {
        tabBar.tintColor = .primaryPurple
        tabBar.backgroundColor = .black
    }
}
