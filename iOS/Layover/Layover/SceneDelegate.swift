//
//  SceneDelegate.swift
//  Layover
//
//  Created by kong on 2023/11/11.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: LoginViewController())
        self.window = window
        addNotificationObservers()
        window.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        if scene == window?.windowScene {
            removeNotificationObservers()
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

// MARK: - NotificationCenter

extension SceneDelegate {

    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(routeToLoginViewController),
                                               name: .refreshTokenDidExpired,
                                               object: nil)
    }

    private func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self,
                                                    name: .refreshTokenDidExpired,
                                                    object: nil)
    }

    @objc private func routeToLoginViewController() {
        guard let rootNavigationViewController = window?.rootViewController as? UINavigationController else { return }
        // TODO: 세션이 만료되었습니다. Toast 띄우기
        rootNavigationViewController.setViewControllers([LoginViewController()], animated: true)
    }
}

