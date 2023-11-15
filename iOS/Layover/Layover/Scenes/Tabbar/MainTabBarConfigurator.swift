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
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        let mapViewController = DummyViewController()
        let profileViewController = DummyViewController()

        let homeIconImage = UIImage(resource: .planet)
        let mapIconImage = UIImage(resource: .map)
        let profileIconImage = UIImage(resource: .star)

        homeViewController.tabBarItem = UITabBarItem(title: "탐사",
                                                     image: homeIconImage.withTintColor(.white),
                                                     selectedImage: nil)
        mapViewController.tabBarItem = UITabBarItem(title: "지도",
                                                    image: mapIconImage.withTintColor(.white),
                                                    selectedImage: nil)
        profileViewController.tabBarItem = UITabBarItem(title: "프로필",
                                                        image: profileIconImage.withTintColor(.white),
                                                        selectedImage: nil)

        viewController.setViewControllers([
            homeViewController,
            mapViewController,
            profileViewController
        ], animated: false)
    }
}
