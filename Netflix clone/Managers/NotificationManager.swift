//
//  NotificationManager.swift
//  Netflix clone
//
//  Created by Oleksandr Smakhtin on 21.01.2023.
//

import Foundation
import UserNotifications


class NotificationManager {
    
    static let shared = NotificationManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    

    func downloadedNotification(title: String) {
        
        // content of notification
        let content = UNMutableNotificationContent()
        content.title = "Netflix-clone"
        content.body = "\(title) - has been successfully downloaded"
        content.sound = UNNotificationSound.default
        
        // trigger of notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // request of notification
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        // sending notification
        notificationCenter.add(request) { error in
            print(error?.localizedDescription)
        }
    }
}

