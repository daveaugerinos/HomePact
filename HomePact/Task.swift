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
    let timestamp: Date
    var taskDate: Date?
    var taskImage: UIImage?
    var notes: String?
    var recurrenceTime: RecurrenceTime = .none
    var messageIds: [String] = []
    
    enum RecurrenceTime {
        case none, minute, hour, day, week, month, year
    }
    
    init(id: String, name: String, timestamp: Date) {
        self.id = id
        self.name = name
        self.timestamp = timestamp
    }
}
