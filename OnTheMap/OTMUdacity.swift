//
//  OTMUdacity.swift
//  OnTheMap
//
//  Created by Julius Danek on 24.06.15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation

extension OTMClient {

    func udacitySessionPOST (HTTTPBody: [String: AnyObject], completitionHandler: (success: Bool, accountID: String?, errorString: String?) -> Void) {
        
        //Construct string
        let urlString = udacity.constants.baseURL + udacity.methods.session
        
        //Configure request
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonifyDict(HTTTPBody)
        
        //initialize task
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            if let error = downloadError {
                completitionHandler(success: false, accountID: nil, errorString: "No network connection")
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                OTMClient.parseJSONWithCompletionHandler(newData, completionHandler: {result, error in
                    if let dataResult: NSDictionary = result as? NSDictionary {
                        
                        if let accountCheck: AnyObject = dataResult.objectForKey(udacity.JSONResponseKeys.account) {
                            
                            if let accountID = accountCheck[udacity.JSONResponseKeys.accountKey] as? String {
                                
                                //assign accountID to value stored in Client
//                                self.accountID = accountID as? String
                                completitionHandler(success: true, accountID: accountID, errorString: nil)
                            }
                        } else {
                            completitionHandler(success: false, accountID: nil, errorString: "Login credentials are not correct")
                        }
                    } else {
                        completitionHandler(success: false, accountID: nil, errorString: "Login failed, please try again")
                    }
                })
            }
        }
        //start request
        task.resume()
    }
    
    //getting user data function
    func getUserData(accountID: String, completitionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let URLString = udacity.constants.baseURL + udacity.methods.getUserData + accountID
        
        let request = NSMutableURLRequest(URL: NSURL(string: URLString)!)
        
        let task = session.dataTaskWithRequest(request) {data, response, error in
            if error != nil {
                println("Error in getting user Data")
                completitionHandler(success: false, errorString: "Login failed, please try again")
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length-5))
                OTMClient.parseJSONWithCompletionHandler(newData, completionHandler: {result, error in
                    if error != nil {
                        completitionHandler(success: false, errorString: "Login failed, please try again")
                    } else {
                        if let dataResult = result as? [String: AnyObject] {
                            if let userData = dataResult[udacity.JSONResponseKeys.user] as? [String: AnyObject]{
                                // getting first and last name from user dictionary, storing it in client, then calling completition handler as successful, even if name variables are empty
                                if let firstName = userData[udacity.JSONResponseKeys.firstName] as? String {
                                    self.userFirstName = firstName
                                }
                                if let lastName = userData[udacity.JSONResponseKeys.lastName] as? String {
                                    self.userLastName = lastName
                                }
                                completitionHandler(success: true, errorString: nil)
                            }
                        }
                    }
                })
            }
        }
        
        task.resume()
        
    }
    
    
//    let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/3903878747")!)
//    
//    let session = NSURLSession.sharedSession()
//    
//    let task = session.dataTaskWithRequest(request) { data, response, error in
//        
//        if error != nil { // Handle error...
//            
//            return
//            
//        }
//        
//        let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
//        
//        println(NSString(data: newData, encoding: NSUTF8StringEncoding))
//        
//    }
//    
//    task.resume()
    
}