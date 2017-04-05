//
//  NotificationManager.swift
//  HomePact
//
//  Created by Callum Davies on 2017-04-01.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject {
    
    func scheduleReminderNotification(withDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "You have a task to do!", arguments: nil)
//        content.body = NSString.localizedUserNotificationString(forKey: "It's your turn next.", arguments: nil)
        
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day, .hour, .minute], from: withDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: "upcoming", content: content, trigger: trigger)
        
        //Schedule request
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
//schedule notification for completed task?
    
}
