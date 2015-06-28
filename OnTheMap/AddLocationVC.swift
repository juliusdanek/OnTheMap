//
//  AddLocationVC.swift
//  OnTheMap
//
//  Created by Julius Danek on 26.06.15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationVC: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var mapString: String?
    var lat: Double?
    var long: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.textField.placeholder = "Enter a location"
        textField.delegate = self
        actionButton.title = "Submit Location"
        actionButton.target = self
        actionButton.action = "geoCodeString"
        self.topLabel.text = "Where on the world are you?"
        self.textField.text = ""
        mapView.hidden = true
        mapView.removeAnnotations(mapView.annotations)
        self.navigationController?.toolbar.hidden = true
    }
    
    func geoCodeString () {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(textField.text, completionHandler: {placemarks, error in
            if error != nil {
                var alert = UIAlertController(title: "Error", message: "Couldn't find location. Please retry", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else if let placemark = placemarks?[0] as? CLPlacemark {
                
                var placemark:CLPlacemark = placemarks[0] as! CLPlacemark
                var coordinates:CLLocationCoordinate2D = placemark.location.coordinate
                
                self.long = placemark.location.coordinate.longitude as Double
                self.lat = placemark.location.coordinate.latitude as Double
                
                var pointAnnotation:MKPointAnnotation = MKPointAnnotation()
                pointAnnotation.coordinate = coordinates
                
                let mapRegion = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpanMake(CLLocationDegrees(0.2), CLLocationDegrees(0.2)))
                
                self.mapView.addAnnotation(pointAnnotation)
                self.mapView.selectAnnotation(pointAnnotation, animated: true)
                self.mapView.setRegion(mapRegion, animated: true)
                
                self.mapString = self.textField.text
                self.mapView.hidden = false
                self.textField.text = ""
                self.textField.placeholder = "Please enter an interesting link"
                self.actionButton.title = "Submit link"
                self.actionButton.action = "submitLink"
                println("Added annotation to map view")
                self.topLabel.text = "What are you studying today?"
            }
        })
        
    }
    
    func mapViewWillStartRenderingMap(mapView: MKMapView!) {
        activityIndicator.startAnimating()
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView!, fullyRendered: Bool) {
        activityIndicator.stopAnimating()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.placeholder == "Enter a location" {
            geoCodeString()
            textField.resignFirstResponder()
        } else {
            submitLink()
        }
        return true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func submitLink () {
        
        let body: [String: AnyObject] = [
            "uniqueKey" : OTMClient.sharedInstance().accountID!,
            "firstName" : OTMClient.sharedInstance().userFirstName!,
            "lastName" : OTMClient.sharedInstance().userLastName!,
            "mapString" : mapString!,
            "mediaURL" : textField.text,
            "latitude" : lat!,
            "longitude": long!
        ]
                
        if OTMClient.sharedInstance().userObjectID == nil {
            OTMClient.sharedInstance().parseLocationUpdate("POST", HTTPBody: body, objectID: nil, completionHandler: {success, error in
                if success {
                    println("location posting successful")
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    println("location posting unsuccessful")
                    println(error)
                }
            })
        } else {
            OTMClient.sharedInstance().parseLocationUpdate("PUT", HTTPBody: body, objectID: OTMClient.sharedInstance().userObjectID, completionHandler: {success, error in
                if success {
                    println("location update sucessful")
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    println("location update unsuccessful")
                    println(error)
                }
            })
        }
    }
    
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

