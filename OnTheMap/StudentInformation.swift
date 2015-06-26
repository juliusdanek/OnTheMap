//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Julius Danek on 26.06.15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    var latitude: Float
    var longitude: Float
    var locationString: String
    
    var firstName: String?
    var lastName: String?
    
    var mediaURL: String?
    
    var uniqueKey: String
    var updatedAt: String
    var updatedAtTI: NSTimeInterval
    
    init (studentDict: [String: AnyObject]) {
        
        //initiallize from JSON object handed down by Parse
        self.firstName = studentDict["firstName"] as? String
        self.lastName = studentDict["lastName"] as? String
        self.latitude = studentDict["latitude"] as! Float
        self.longitude = studentDict["longitude"] as! Float
        self.locationString = studentDict["mapString"] as! String
        self.mediaURL = studentDict["mediaURL"] as? String
        self.uniqueKey = studentDict["uniqueKey"] as! String
        self.updatedAt = studentDict["updatedAt"] as! String
        self.updatedAtTI = OTMClient.sharedInstance().timeConversion(studentDict["updatedAt"] as! String)
        
    }
    
    
}

