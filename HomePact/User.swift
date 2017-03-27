//
//  User.swift
//  HomePact
//
//  Created by Dave Augerinos on 2017-03-27.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

struct User {

    let id: String
    let token: String
    let username: String
    let timestamp: Date
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var userImage: UIImage?

    init(id: String, token: String, username: String, timestamp: Date) {
        self.id = id
        self.token = token
        self.username = username
        self.timestamp = timestamp
    }
}
