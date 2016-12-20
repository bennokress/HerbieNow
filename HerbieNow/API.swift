//
//  API.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

protocol API {

    typealias callback = (APICallResult) -> ()

    /// Login with credentials from Keychain -> returns Bool, if successful or not
    func login( completion: @escaping callback )

    /// Get User Data retrieves the Open-Car-Token for DriveNow -> returns Bool, if successful or not
    func getUserData( completion: @escaping callback )

    /// Gets current reservation status for the User -> returns Reservation? (nil if no reservation is active)
    func getReservationStatus( completion: @escaping callback )

    /// Gets a list of vehicles for the nearest city to current location -> returns [Vehicle]
    func getAvailableVehicles(around location: Location, completion: @escaping callback)

    /// Reserves the specified car -> returns Bool, if successful or not
    func reserveVehicle(withVIN vin: String, completion: @escaping callback)

    /// Cancels the current reservation -> returns Bool, if successful or not
    func cancelReservation( completion: @escaping callback )

    /// Opens the specified car -> returns Bool, if successful or not
    func openVehicle(withVIN vin: String, completion: @escaping callback)

    /// Closes the specified car -> returns Bool, if successful or not
    func closeVehicle(withVIN vin: String, completion: @escaping callback)

}
