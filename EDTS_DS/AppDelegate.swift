//
//  AppDelegate.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 08/04/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        EDTSColor.theme = .klikIDM
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let initialVC = storyboard.instantiateInitialViewController() {
            // Directly set the initial view controller without wrapping it
            window?.rootViewController = initialVC
        } else {
            // Fallback in case the storyboard doesn't have an initial view controller
            let fallbackVC = UIViewController()
            fallbackVC.view.backgroundColor = .white
            window?.rootViewController = fallbackVC
        }
        
        window?.makeKeyAndVisible()
        return true
    }

//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        EDTSColor.theme = .klikIDM
//        // Override point for customization after application launch.
//        return true
//    }
//
//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

