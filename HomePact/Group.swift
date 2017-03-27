//
//  Group.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

struct Group {
    let id: String
    let name: String
    let timestamp: Date
    var groupImage: UIImage?

    init(id: String, name: String, timestamp: Date) {
        self.id = id
        self.name = name
        self.timestamp = timestamp
    }
}
