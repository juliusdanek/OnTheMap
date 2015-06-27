//
//  MapView.swift
//  OnTheMap
//
//  Created by Julius Danek on 26.06.15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapView: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "populateMapView", name: "syncButton", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.delegate = self
    }

    func populateMapView () {

        var annotations = [MKPointAnnotation]()
        
        for student in OTMClient.sharedInstance().studentData {
            
            var annotation = MKPointAnnotation()
            annotation.coordinate = student.coordinate
            annotation.title = "\(student.firstName!) \(student.lastName!)"
            annotation.subtitle = student.mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            //remove all previous annotations and add the new ones
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
        })
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        println("tapped")
        //Check whether they are valid URLs
        if control == annotationView.rightCalloutAccessoryView {
            if let url = annotationView.annotation.subtitle {
                if let safariURL = NSURL(string: url) {
                    UIApplication.sharedApplication().openURL(safariURL)
                }
            }
        }
    }
    
    override func viewWillDisappear(animated:Bool){
        super.viewWillDisappear(animated)
    }
    
}
