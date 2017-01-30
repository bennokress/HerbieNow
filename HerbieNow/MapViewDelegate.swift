//
//  MapViewDelegate.swift
//  HerbieNow
//
//  Created by M Z on 30/01/2017.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    
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
