//
//  AppDelegate.swift
//  ForEvents
//
//  Created by luis gomez alonso on 16/10/18.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        //UserDefaults.standard.removeObject(forKey: "hasLoginKey")
        //UserDefaults.standard.removeObject(forKey: "username")
        
        // Check if app have a token
        let hasLogin = UserDefaults.standard.bool(forKey: Constants.hasLoginKey)
        if hasLogin {
            if let username = UserDefaults.standard.value(forKey: Constants.username) {
                if checkToken(username: username as! String) != nil {
                    let eventsTabBarController = createEventsTabBar()
                    window?.rootViewController = eventsTabBarController
                }
            }
        } else {
            let loginTabBarController = LoginTabBarController()
            // Check if app have a username, then register screen is show
            let username = UserDefaults.standard.value(forKey: Constants.username)
            if username == nil {
                loginTabBarController.selectedIndex = 1
            }
            
            window?.rootViewController = loginTabBarController
        }
        
        return true
    }
    
}

