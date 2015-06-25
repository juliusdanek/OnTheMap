//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Julius Danek on 24.06.15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation

class OTMClient: NSObject {
    
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    //Auth State
    
    var accountID: String? = nil
    
    //User info
    
    var userFirstName: String? = nil
    var userLastName: String? = nil
    
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
    
    class func sharedInstance() -> OTMClient {
        
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        
        return Singleton.sharedInstance
    }
    
}