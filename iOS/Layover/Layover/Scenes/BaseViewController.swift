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

    func setConstraints() {
        // Set AutoLayout
    }

    func setUI() {
        // Set UI
        view.backgroundColor = UIColor.background
    }
}
