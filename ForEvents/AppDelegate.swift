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
        
        // Check if app have a token
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLoginKey")
        if hasLogin {
            if let username = UserDefaults.standard.object(forKey: "username") {
                let token = ValidateToken().checkToken(username: username as! String)
                print("token: \(token)")
            }
        } else {
            let loginTabBarController = LoginTabBarController()
            window?.rootViewController = loginTabBarController
        }
        
        return true
    }
    
}

