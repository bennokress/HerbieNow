//
//  API.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.12.16.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation

protocol API {

    typealias Callback = (APICallResult) -> Void

    /// Login with credentials from Keychain -> returns Bool, if successful or not
    func login(completion: @escaping Callback )

    /// Get User Data retrieves the Open-Car-Token for DriveNow -> returns Bool, if successful or not
    func getUserData( completion: @escaping Callback )

    /// Gets current reservation status for the User -> returns Reservation? (nil if no reservation is active)
    func getReservationStatus( completion: @escaping Callback )

    /// Gets a list of vehicles for the nearest city to current location -> returns [Vehicle]
    func getAvailableVehicles(around location: Location, completion: @escaping Callback)

    /// Reserves the specified car -> returns Bool, if successful or not
    func reserveVehicle(withVIN vin: String, completion: @escaping Callback)

    /// Cancels the current reservation -> returns Bool, if successful or not
    func cancelReservation( completion: @escaping Callback )

    /// Opens the specified car -> returns Bool, if successful or not
    func openVehicle(withVIN vin: String, completion: @escaping Callback)

    /// Closes the specified car -> returns Bool, if successful or not
    func closeVehicle(withVIN vin: String, completion: @escaping Callback)

}
