//
//  AppDelegate.swift
//  Spotify
//
//  Created by Alex on 2024/6/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        if AuthManager.shared.isSignedIn {
            AuthManager.shared.refreshAccessToken(completion: nil)
            window.rootViewController = TabBarViewController()
        }else {
            let navC = UINavigationController(rootViewController: WelcomeViewController())
            navC.navigationBar.prefersLargeTitles = true
            navC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
            window.rootViewController = navC
        }
        
        window.makeKeyAndVisible()
        self.window = window
        
//        AuthManager.shared.refreshAccessToken { success in
//            print(<#T##items: Any...##Any#>)
//        }
        
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


}

