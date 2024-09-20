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

    var progressView: UIProgressView = UIProgressView(progressViewStyle: .bar)
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let rootViewController = AuthManager.shared.isLoggedIn == true ? MainTabBarViewController() : LoginViewController()
        let rootNavigationController = UINavigationController(rootViewController: rootViewController)

        if rootViewController is MainTabBarViewController {
            rootNavigationController.setNavigationBarHidden(true, animated: false)
        }

        window.rootViewController = rootNavigationController
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
        NotificationCenter.default.addObserver(forName: .uploadTaskStart, object: nil, queue: .main) { [weak self] _ in
           self?.showProgressView()
        }
        NotificationCenter.default.addObserver(forName: .progressChanged, object: nil, queue: .main) { [weak self] notification in
            guard let progress = notification.userInfo?["progress"] as? Float else { return }
            self?.progressView.setProgress(progress, animated: true)
        }
        NotificationCenter.default.addObserver(forName: .uploadTaskDidComplete, object: nil, queue: .main) { [weak self] _ in
            self?.removeProgressView(message: "업로드가 완료되었습니다 ✨")
        }
        NotificationCenter.default.addObserver(forName: .uploadTaskDidFail, object: nil, queue: .main) { [weak self] _ in
            self?.removeProgressView(message: "업로드에 실패했습니다 💦")
        }
    }

    private func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .refreshTokenDidExpired,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .uploadTaskStart,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .progressChanged,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .uploadTaskDidComplete,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .uploadTaskDidFail,
                                                  object: nil)
    }

    @objc private func routeToLoginViewController() {
        guard let rootNavigationViewController = window?.rootViewController as? UINavigationController else { return }
        Toast.shared.showToast(message: "세션이 만료되었습니다.")
        rootNavigationViewController.setNavigationBarHidden(false, animated: false)
        rootNavigationViewController.setViewControllers([LoginViewController()], animated: true)
    }

    private func showProgressView() {
        guard let progressViewWidth = window?.screen.bounds.width,
              let windowHeight = window?.screen.bounds.height,
              let navigationController = window?.rootViewController as? UINavigationController,
              let tabBarController = navigationController.topViewController as? UITabBarController
        else { return }
        let tabBarHeight: CGFloat = tabBarController.tabBar.frame.height
        progressView.progress = 0
        progressView.tintColor = .primaryPurple
        progressView.frame = CGRect(x: 0,
                                    y: (windowHeight - tabBarHeight - 2),
                                    width: progressViewWidth,
                                    height: 2)
        window?.addSubview(progressView)
    }

    private func removeProgressView(message: String) {
        progressView.removeFromSuperview()
        Toast.shared.showToast(message: message)
    }

}

