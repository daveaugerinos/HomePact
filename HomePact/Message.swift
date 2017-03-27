//
//  Message.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

struct Message {
    let id: String
    let senderName: String
    let timestamp: Date
    var senderImage: UIImage?
    var messageText: String?
    var messageImage: UIImage?
    var messageVideo: URL?

    init(id: String, senderName: String, timestamp: Date) {
        self.id = id
        self.senderName = senderName
        self.timestamp = timestamp
    }
}
