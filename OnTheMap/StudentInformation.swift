//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Julius Danek on 26.06.15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation
import MapKit

struct StudentInformation {
    
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var locationString: String
    var coordinate: CLLocationCoordinate2D

    var firstName: String?
    var lastName: String?
    
    var mediaURL: String?
    
    var uniqueKey: String
    var updatedAt: NSDate
    
    init (studentDict: [String: AnyObject]) {
        
        //initiallize from JSON object handed down by Parse
        self.firstName = studentDict["firstName"] as? String
        self.lastName = studentDict["lastName"] as? String
        self.latitude = CLLocationDegrees(studentDict["latitude"] as! Double)
        self.longitude = CLLocationDegrees(studentDict["longitude"] as! Double)
        self.locationString = studentDict["mapString"] as! String
        self.mediaURL = studentDict["mediaURL"] as? String
        self.uniqueKey = studentDict["uniqueKey"] as! String
        self.updatedAt = OTMClient.sharedInstance().timeConversion(studentDict["updatedAt"] as! String)
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
    }
    
    
    
    
}

