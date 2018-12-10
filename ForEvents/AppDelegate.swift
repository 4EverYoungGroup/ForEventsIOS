//
//  AppDelegate.swift
//  ForEvents
//
//  Created by luis gomez alonso on 16/10/18.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        self.registerForPushNotifications(application)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        //UserDefaults.standard.removeObject(forKey: "hasLoginKey")
        //UserDefaults.standard.removeObject(forKey: "username")
        //UserDefaults.standard.removeObject(forKey: "radio")
        //UserDefaults.standard.removeObject(forKey: Constants.eventTypesCheckPref)
        
        // Check if app have a token
        if UserDefaults.standard.bool(forKey: Constants.hasLoginKey) == true {
            if let username = UserDefaults.standard.value(forKey: Constants.useremail) {
                if checkToken(username: username as! String) != nil {
                    let eventsTabBarController = createEventsTabBar()
                    //Configure tabbar opaque and black
                    eventsTabBarController.tabBar.isOpaque = true
                    eventsTabBarController.tabBar.barTintColor = .black
                    
                    window?.rootViewController = eventsTabBarController
                }
            }
        } else {
            let loginTabBarController = createLoginTabBar()
            // Check if app have a username, then register screen is show
            let username = UserDefaults.standard.value(forKey: Constants.useremail)
            if username == nil {
                loginTabBarController.selectedIndex = 1
            }
            //Configure tabbar without background and shadow
            loginTabBarController.tabBar.backgroundImage = UIImage()
            loginTabBarController.tabBar.shadowImage = UIImage()
            
            window?.rootViewController = loginTabBarController
        }
        
        return true
    }
    
}

