//
//  MainTabBarConfigurator.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import UIKit

final class MainTabBarConfigurator: Configurator {
    static let shared = MainTabBarConfigurator()

    private init() { }

    // TODO: 뷰컨트롤러, 탭바 아이템 교체
    func configure(_ viewController: UITabBarController) {

        let homeViewController = DummyViewController()
        let mapViewController = DummyViewController()
        let profileViewController = DummyViewController()

        homeViewController.tabBarItem = UITabBarItem(title: "탐사", image: UIImage(systemName: "square.and.arrow.up"), selectedImage: nil)
        mapViewController.tabBarItem = UITabBarItem(title: "지도", image: UIImage(systemName: "square.and.arrow.up"), selectedImage: nil)
        profileViewController.tabBarItem = UITabBarItem(title: "프로필", image: UIImage(systemName: "square.and.arrow.up"), selectedImage: nil)

        viewController.setViewControllers([
            homeViewController,
            mapViewController,
            profileViewController
        ], animated: false)
    }
}
