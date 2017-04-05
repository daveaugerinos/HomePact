//
//  Task.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

struct Task {
    let id: String
    let name: String
    var timestamp: Date
    var taskDate: Date?
    var taskImage: UIImage?
    var notes: String?
    var recurrenceTime: RecurrenceTime = .none
    var messageIds: [String] = []
    var isCompleted = false
    
    
    enum RecurrenceTime:String {
        case none = "none", minute = "minute", hour = "hour", day = "day", week = "week", month = "month", year = "year"
        
    }
    
    init(id: String, name: String, timestamp: Date) {
        self.id = id
        self.name = name
        self.timestamp = timestamp
        
    }
}
