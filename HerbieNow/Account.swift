//
//  Account.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

class Account {

    var provider: Provider
    var username: String
    var password: String

    init(provider: Provider, username: String, password: String) {
        self.provider = provider
        self.username = username
        self.password = password
    }

}
