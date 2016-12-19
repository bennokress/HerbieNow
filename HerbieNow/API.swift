//
//  API.swift
//  HerbieNow
//
//  Created by Benno Kress on 13.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

protocol API {

    /// Login with credentials from UserDefaults (username) and Keychain (password) -> returns Bool, if successful or not
    func login()
    
    /// Get User Data retrieves the Open-Car-Token for DriveNow -> returns Bool, if successful or not
    func getUserData()
    
    /// Gets current reservation status for the User -> returns Reservation? (nil if no reservation is active)
    func getReservationStatus()
    
    /// Gets a list of vehicles for the nearest city to current location -> returns [Vehicle]
    func getAvailableVehicles(around latitude: Double, _ longitude: Double)
    
    /// Reserves the specified car -> returns Bool, if successful or not
    func reserveVehicle(withVIN vin: String)
    
    /// Cancels the current reservation -> returns Bool, if successful or not
    func cancelReservation()
    
    /// Opens the specified car -> returns Bool, if successful or not
    func openVehicle(withVIN vin: String)
    
    /// Closes the specified car -> returns Bool, if successful or not
    func closeVehicle(withVIN vin: String)

}
