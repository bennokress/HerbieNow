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
    
    func centerMap(on location: Location)
    func showMyLocation(at location: Location)
    func showAnnotations(for vehicles: [Vehicle])
    func goBackToMainView()

}

// MARK: -
class VehicleMapViewController: UIViewController {

    lazy var interpreter: VehicleMapViewInterpreterProtocol = VehicleMapViewInterpreter(for: self, appDelegate: UIApplication.shared.delegate as! AppDelegate)
    var delegate: MapViewDelegate? = nil
    
    let segueIdentifier = "unwindToMainView"
    
    // MARK: Data & Settings
    
    var data: ViewData? = nil
    let zoomRadius: CLLocationDistance = 1000
    
    // MARK: UI Elements

    @IBOutlet weak fileprivate var mapViewOutlet: MKMapView!
    @IBOutlet weak fileprivate var backButton: UIButton!
    
    // MARK: Mandatory View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Debug.print(.event(source: .location(Source()), description: "View Did Load"))
        setExclusiveTouchForAllButtons()
        mapViewOutlet.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Debug.print(.event(source: .location(Source()), description: "View Did Appear"))
        interpreter.viewDidAppear(with: data)
        delegate?.dismissLoadingAnimation()
    }
    
    // MARK: UI Element Interaction Functions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        interpreter.backButtonPressed()
    }
}

// MARK: - Vehicle Map View Controller Protocol Conformance
extension VehicleMapViewController: VehicleMapViewControllerProtocol {

    func centerMap(on location: Location) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.asObject.coordinate, zoomRadius * 2.0, zoomRadius * 2.0)
        mapViewOutlet.setRegion(coordinateRegion, animated: true)
    }
    
    func showMyLocation(at location: Location) {
        let myAnnotation = PinAnnotation(title: "Me", locationName: "I am here", discipline: "Person", coordinate: location.asObject.coordinate, color: UIColor.brown)
        mapViewOutlet.addAnnotation(myAnnotation)
    }
    
    func showAnnotations(for vehicles: [Vehicle]) {
        Debug.print(.info(source: .location(Source()), message: "Presenting \(vehicles.count) vehicles on the map."))
        var annotations: [PinAnnotation] = []
        
        // iterate through vehicles to set every pin
        for vehicle in vehicles {
            var color: UIColor
            if(vehicle.provider == .driveNow){
                color = UIColor.blue
            } else {
                color = UIColor.red
            }
            
            let anno = PinAnnotation(title: "Car",
                                     locationName: vehicle.description,
                                     discipline: "Car",
                                     coordinate: vehicle.location.asObject.coordinate,
                                     color: color)
            annotations.append(anno)
        }
        mapViewOutlet.addAnnotations(annotations)
    }
    
    func goBackToMainView() {
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
}

// MARK: - Map View Delegate Conformance
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

// MARK: - Internal Functions
extension VehicleMapViewController: InternalRouting {
    
    fileprivate func setExclusiveTouchForAllButtons() {
        for case let button as UIButton in self.view.subviews {
            button.isExclusiveTouch = true
        }
    }
    
}
