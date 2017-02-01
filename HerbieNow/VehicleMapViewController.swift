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
        // TODO: perform actual reservation
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
            vehicle.detailsForLine3 { line3String in
                let anno = PinAnnotation(vehicle: vehicle, userDistance: line3String)
                annotations.append(anno)
                self.mapViewOutlet.addAnnotations(annotations)
            }
            
        }
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
                view.canShowCallout = false
            }
            return view
        }
        return nil
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
    
    }
    
    /*
  
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
        // 1
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        // 2
        let starbucksAnnotation = view.annotation as! StarbucksAnnotation
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        calloutView.starbucksName.text = starbucksAnnotation.name
        calloutView.starbucksAddress.text = starbucksAnnotation.address
        calloutView.starbucksPhone.text = starbucksAnnotation.phone
        
        //
        let button = UIButton(frame: calloutView.starbucksPhone.frame)
        button.addTarget(self, action: #selector(ViewController.callPhoneNumber(sender:)), for: .touchUpInside)
        calloutView.addSubview(button)
        calloutView.starbucksImage.image = starbucksAnnotation.image
        // 3
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.2)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
 */

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
