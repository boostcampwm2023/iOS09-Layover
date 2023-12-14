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

    func showLoading() {
        let loadingIndicatorView: UIActivityIndicatorView
        if let existedView = view.window?.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
            loadingIndicatorView = existedView
        } else {
            loadingIndicatorView = UIActivityIndicatorView(style: .large)
            loadingIndicatorView.color = UIColor.primaryPurple
            /// 다른 UI가 눌리지 않도록 indicatorView의 크기를 full로 할당
            loadingIndicatorView.frame = view.window?.frame ?? view.bounds
            view.window?.addSubview(loadingIndicatorView)
        }
        loadingIndicatorView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        loadingIndicatorView.startAnimating()
    }

    func hideLoading() {
        view.window?.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
    }
}
