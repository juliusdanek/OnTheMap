//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Julius Danek on 24.06.15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

class OTMClient: NSObject {
    
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    //Auth State
    
    var accountID: String? = nil
    
    //Bool to check whether to log-in was performed with facebook or not
    
    var FBLogin: Bool = false
    var loginManager = FBSDKLoginManager()

    
    //User info
    
    var userFirstName: String? = nil
    var userLastName: String? = nil
    var userObjectID: String? = nil
    
    
    //array with student data
    
    var studentData = [StudentInformation]()
    
    //
    
    //Helper: jsonify a dictionary
    func jsonifyDict (dict: [String: AnyObject]) -> NSData? {
        
        var jsonifyError: NSError? = nil
        
        let jsonifiedDict = NSJSONSerialization.dataWithJSONObject(dict, options: nil, error: &jsonifyError)
        
        if let result = jsonifiedDict {
            return jsonifiedDict!
        } else {
            println("error at jsonifiying")
            return nil
        }
    }

    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    //Helper: to convert updated time into time interval --> to check what the most recent update was
    func timeConversion(date: String) -> NSDate {
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        var dateAsNSDATE = dateFormatter.dateFromString(date)
        
        return dateAsNSDATE!
        
    }
    
    class func sharedInstance() -> OTMClient {
        
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        
        return Singleton.sharedInstance
    }
    
}