//
//  AppDelegate+Notifications.swift
//  ForEvents
//
//  Created by luis gomez alonso on 04/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func registerForPushNotifications(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (_,_) in
                
            }
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("NOTIFICATION: Registration token  =>  \(fcmToken)")
        UserDefaults.standard.setValue(fcmToken, forKey: Constants.tokenDevice)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        //Recover from notification eventId.
        guard let data = try? JSONSerialization.data(withJSONObject: userInfo, options: []) as Data else { return }
        let decoder = JSONDecoder()
        let notificationDict = try? decoder.decode(NotificationEvent.self, from: data)
        let eventId = notificationDict?.eventId
        let notificationEventViewController = NotificationEventViewController()
        notificationEventViewController.eventId = eventId
        window?.rootViewController?.present(notificationEventViewController, animated: true, completion: nil)
        
    }
    
}
