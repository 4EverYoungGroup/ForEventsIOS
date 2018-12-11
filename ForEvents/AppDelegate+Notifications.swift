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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notifiction: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        processNotification(notifiction)
        completionHandler(.badge)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        processNotification(response.notification)
        completionHandler()
    }
    
    private func processNotification(_ notification: UNNotification) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("NOTIFICATION: Received data message => \(notification)")
    }
    
    func application(received remoteMessage: MessagingRemoteMessage)
    {
        // What message comes here?
        
        print("remoteMessage.appData : ", remoteMessage.appData)
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("NOTIFICATION: Registration token  =>  \(fcmToken)")
        UserDefaults.standard.setValue(fcmToken, forKey: Constants.tokenDevice)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("NOTIFICATION: Received data message => \(remoteMessage.appData)")
        guard let data = try? JSONSerialization.data(withJSONObject: remoteMessage.appData, options:.prettyPrinted),
            let prettyPrinted = String(data: data, encoding: .utf8) else { return }
        print("Received direct channel message:\n\(prettyPrinted)")
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("[RemoteNotification] didRefreshRegistrationToken: \(fcmToken)")
    }
    
    
}
