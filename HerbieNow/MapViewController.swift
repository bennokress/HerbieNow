//
//  MapViewController.swift
//  HerbieNow
//
//  Created by M Z on 30/01/2017.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    //cmd drag mit der map view im storyboard
    @IBOutlet weak var mapView: MKMapView!
    
    //nur fuers testen, kommt aus dem model
    let initialLocation = CLLocation(latitude: 48.149960, longitude: 11.594359)
    //zoomradius
    let regionRadius:CLLocationDistance = 1000
    
    
    //test funktion fuer dummy-autos
    func getVehicles() -> [Vehicle] {
        var vehicleList: [Vehicle] = []
        vehicleList.append(Vehicle(provider: "DriveNow",
                                   model: "BMW",
                                   location: CLLocationCoordinate2D(latitude: 48.150500, longitude: 11.595638)))
        vehicleList.append(Vehicle(provider: "DriveNow",
                                   model: "Smart",
                                   location: CLLocationCoordinate2D(latitude: 48.149954, longitude: 11.595037)))
        vehicleList.append(Vehicle(provider: "DriveNow",
                                   model: "Mercedes",
                                   location: CLLocationCoordinate2D(latitude: 48.150226, longitude: 11.595155)))
        vehicleList.append(Vehicle(provider: "Car2Go",
                                   model: "BMW",
                                   location: CLLocationCoordinate2D(latitude: 48.150827, longitude: 11.595085)))
        vehicleList.append(Vehicle(provider: "Car2Go",
                                   model: "Smart",
                                   location: CLLocationCoordinate2D(latitude: 48.148980, longitude: 11.594608)))
        return vehicleList
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation(location: initialLocation)
        mapView.delegate = self
        var annotations: [MyAnnotation] = []
        for vehicle in getVehicles() {
            var color: UIColor
            if vehicle.provider == "DriveNow" {
                color = UIColor.red
            }else{
                color = UIColor.blue
            }
            let anno = MyAnnotation(title: "Car", locationName: vehicle.getDescription(), discipline: "Car", coordinate: vehicle.location, color: color)
            annotations.append(anno)
        }
        mapView.addAnnotations(annotations)
    }
    
    
}

