//
//  User.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

class User {

    // Singleton - call via User.shared
    static var shared = User()

    var hasAtLeastOneAccountConfigured: Bool {
        return hasConfiguredAccount(for: .driveNow) || hasConfiguredAccount(for: .car2go)
    }

    // MARK: DriveNow
    var xAuthToken: String? = nil // maybe move to keychain for more security
    var openCarToken: String? = nil // maybe move to keychain for more security

    // MARK: Car2Go
    // TODO: List necessary User Data to be stored in model

    private init() {

    }

    func hasConfiguredAccount(for provider: Provider) -> Bool {
        // TODO: Add logic by querying, if username and password is stored -> change return value
        return true
    }

}
