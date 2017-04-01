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
        content.title = NSString.localizedUserNotificationString(forKey: "Wake up!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Rise and shine! It's morning time!",
                                                                arguments: nil)
        
        // Configure the trigger for a 7am wakeup.
        var dateInfo = DateComponents()
        dateInfo.hour = 7
        dateInfo.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: "MorningAlarm", content: content, trigger: trigger)
    }
    
}
