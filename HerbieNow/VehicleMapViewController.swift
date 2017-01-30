//
//  VehicleMapViewController.swift
//  HerbieNow
//
//  Created by M Z on 30/01/2017.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol VehicleMapViewControllerProtocol: class {

}

class VehicleMapViewController: UIViewController {

    // swiftlint:disable:next force_cast
    lazy var interpreter: VehicleMapInterpreterProtocol = VehicleMapInterpreter(for: self, appDelegate: UIApplication.shared.delegate as! AppDelegate)

    @IBOutlet weak private var mapView: MKMapView!

    // nur fuers testen, kommt aus dem model
    let initialLocation = CLLocation(latitude: 48.149960, longitude: 11.594359)
    // zoomradius
    let regionRadius:CLLocationDistance = 1000

    // test funktion fuer dummy-autos
    func getVehicles() -> [Vehicle] {
        let vehicleList: [Vehicle] = []
        /*
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
         */
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
        var annotations: [PinAnnotation] = []
        // iterate through vehicles to set every pin
        for _ in getVehicles() {
            var color: UIColor
            // hier z.B.: if drivenow -> red, else -> blue
            color = UIColor.red

            let anno = PinAnnotation(title: "Car", locationName: "vehicle.getDescription()", discipline: "Car", coordinate: CLLocationCoordinate2DMake(0, 0), color: color)
            annotations.append(anno)
        }
        mapView.addAnnotations(annotations)
    }

}

extension VehicleMapViewController: VehicleMapViewControllerProtocol {

}

extension VehicleMapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? PinAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                let coloredAnnotation = annotation
                view.pinTintColor = coloredAnnotation.color
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                /*
                 let calloutButton = UIButton(type: .custom)
                 calloutButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
                 calloutButton.layer.borderWidth = 1
                 calloutButton.layer.borderColor = UIColor.black.cgColor
                 calloutButton.setTitle("Reservieren", for: .normal)
                 */
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Action for pressing on "info-Button"
        print("Button tapped")
        if let annot = view.annotation as? PinAnnotation {
            // alert window
            let ac = UIAlertController(title: "Hier kann man nun reservieren",
                                       message: annot.locationName,
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }

    }

}
