//
//  AppDelegate.swift
//  Layover
//
//  Created by kong on 2023/11/11.
//

import UIKit
import KakaoSDKCommon
import HLSCachingServer

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let hlsCachingServer = HLSCachingServer(urlSession: .shared, urlCache: .shared)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // remove keychain data when app is first launched
        if System.isFirstLaunch() {
            AuthManager.shared.logout()
        }

        // kakao
        guard let KAKAO_APP_KEY = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String else { return true }
        KakaoSDK.initSDK(appKey: KAKAO_APP_KEY)

        setNavigationControllerAppearance()
        setTabBarAppearance()

        hlsCachingServer.start(port: 12345)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    private func setNavigationControllerAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.setBackIndicatorImage(UIImage.iconTabBack, transitionMaskImage: UIImage.iconTabBack)
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    }

    private func setTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

