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
    func showAnnotations(for vehicles: [Vehicle])
    func goBackToMainView()
    func showConfirmationPopUp()

}

// MARK: -
class VehicleMapViewController: UIViewController {

    lazy var interpreter: VehicleMapViewInterpreterProtocol = VehicleMapViewInterpreter(for: self, appDelegate: UIApplication.shared.delegate as! AppDelegate)
    var delegate: MapViewDelegate? = nil
    
    let segueIdentifier = "unwindToMainView"
    
    // MARK: Data & Settings
    
    var data: ViewData? = nil
    let zoomRadius: CLLocationDistance = 1000
    var currentVehicle: Vehicle? = nil
    
    // MARK: UI Elements

    @IBOutlet weak fileprivate var mapViewOutlet: MKMapView!
    @IBOutlet weak fileprivate var backButton: UIButton!
    
    // MARK: Vehicle Detailed View Elements
    
    @IBOutlet weak fileprivate var overlayView: UIView!
    
    @IBOutlet weak fileprivate var reserveButton: UIButton!
    @IBOutlet weak fileprivate var vehicleImage: UIImageView!
    @IBOutlet weak fileprivate var line1Label: UILabel!
    @IBOutlet weak fileprivate var line2Label: UILabel!
    @IBOutlet weak fileprivate var line3Label: UILabel!
    
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
    
    
    @IBAction func reserveButtonPressed(_ sender: Any) {
        Debug.print(.event(source: .location(Source()), description: "Reserve Button Pressed"))
        interpreter.performReservation(for: currentVehicle!)
    }
}

// MARK: - Vehicle Map View Controller Protocol Conformance
extension VehicleMapViewController: VehicleMapViewControllerProtocol {

    func centerMap(on location: Location) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.asObject.coordinate, zoomRadius * 2.0, zoomRadius * 2.0)
        mapViewOutlet.setRegion(coordinateRegion, animated: true)
    }
    
    func showAnnotations(for vehicles: [Vehicle]) {
        Debug.print(.info(source: .location(Source()), message: "Presenting \(vehicles.count) vehicles on the map."))
        var annotations: [PinAnnotation] = []
        
        // iterate through vehicles to set every pin
        for vehicle in vehicles {
            let anno = PinAnnotation(vehicle: vehicle)
            annotations.append(anno)
            self.mapViewOutlet.addAnnotations(annotations)
        }
    }
    
    func goBackToMainView() {
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    func showConfirmationPopUp() {
        // alert window
        let ac = UIAlertController(title: "Success",
                                   message: "Reservation was successful",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
        // hide detail window
        overlayView.isHidden = true
    }
}

// MARK: - Map View Delegate Conformance
extension VehicleMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let annotationIdentifier = "pin"
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            annotationView.canShowCallout = false
            if annotation is PinAnnotation {
                let customAnnotation: PinAnnotation = annotation as! PinAnnotation
                annotationView.image = customAnnotation.pin
            }
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            // Don't proceed with custom callout
            return
        }
        
        overlayView.isHidden = false
        let selectedAnnotation = view.annotation as! PinAnnotation
        
        // set values of calloutView
        line1Label.text = selectedAnnotation.verhicleDescription
        line2Label.text = selectedAnnotation.fuelInfo
        line3Label.text = selectedAnnotation.distanceUser
        
        vehicleImage.image = selectedAnnotation.image
        
        currentVehicle = selectedAnnotation.vehicleObject
    
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Action for pressing on "info-Button"
        if let annot = view.annotation as? PinAnnotation {
            // alert window
            let ac = UIAlertController(title: "Hier kann man nun reservieren",
                                       message: annot.description,
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }

    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self) {
            // overlayView.isHidden = true
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
