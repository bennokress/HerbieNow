//
//  Location.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation
import CoreLocation

class Location: CLLocationManagerDelegate {
    
    // Location Manager:
    let locationManager = CLLocationManager()
    // Test data
    let latitudeTest = 50.0
    let longitudeTest = 50.0
    
    
    

    //    let street: String
    //    let areaCode: String
    //    let city: String
    let latitude: Double
    let longitude: Double

    let coordinateDescription: String

    //    init(street: String, areaCode: String, city: String) {
    //        self.street = street
    //        self.areaCode = areaCode
    //        self.city = city
    //    }

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude

        coordinateDescription = "lat: \(latitude), long: \(longitude)"
    }

    
    
    
    //gets the location (in coordinates) from the locationManager
    func findMyLocation(sender: AnyObject){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let location = self.locationManager.location
        var latitude: Double = location?.coordinate.latitude
        var longitude: Double = location?.coordinate.longitude
        
        print(latitude)
        print(longitude)
    }
    
    //we have to override this function (to get notified when locationManager retrieves current location)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error) -> Void in
            
            if (error != nil){
                print("Reverse Geocoder failed with error" + error.localizedDesciption)
                return
            }
            
            if (placemarks.count > 0){
                let pm = placemarks[0] as CLPlacemark
                self.desplayLocationInfo(pm)
            }else{
                print("Problem with data received from geocoder")
            }
        })
                
    }
    
    func displayLocationInfo(placemark: CLPlacemark?){
        if let containsPlacemark = placemark{
            //stop updating the automatic location update
            locaionManager.stopUpdatingLocation()
            
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            print(locality)
            print(postalCode)
            print(administrativeArea)
            print(country)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location" + error.localizedDescription)
    }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    
    
    
}
