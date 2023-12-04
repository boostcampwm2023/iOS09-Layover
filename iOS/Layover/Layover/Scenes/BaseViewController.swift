//
//  BaseViewController.swift
//  Layover
//
//  Created by 김인환 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
    }

    // MARK: - ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        setUI()
    }

    // MARK: - Methods

    /// Call when ViewDidLoad
    func setConstraints() {
        // Set AutoLayout
    }

    /// Call when ViewDidLoad After setConstraints()
    func setUI() {
        view.backgroundColor = UIColor.background
        navigationItem.backBarButtonItem = UIBarButtonItem(
                title: "", style: .plain, target: nil, action: nil)
    }
}
