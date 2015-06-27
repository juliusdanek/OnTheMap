//
//  OTMParse.swift
//  OnTheMap
//
//  Created by Julius Danek on 26.06.15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation

extension OTMClient {
    
    func parseGet (completionHandler: (success: Bool, error: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: parse.baseURL)!)
        request.addValue(parse.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(parse.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, error: "Network failure, could not download data")
            } else {
                OTMClient.parseJSONWithCompletionHandler(data, completionHandler: {result, error in
                    if let dataResult = result as? [String: AnyObject] {
                        if let dataArray = dataResult["results"] as? [[String: AnyObject]] {
                            //remove all previous data and replace it with new data from Parse
                            OTMClient.sharedInstance().studentData.removeAll(keepCapacity: true)
                            for element in dataArray {
                                let studentObject = StudentInformation(studentDict: element)
                                OTMClient.sharedInstance().studentData.append(studentObject)
                            }
                            completionHandler(success: true, error: nil)
                        }
                    } else {
                        completionHandler(success: false, error: "Could not process the data")
                    }
                    
                })
            }
        }
        
        task.resume()
    }
    
    func parseLocationUpdate (HTTPMethod: String, HTTPBody: [String: AnyObject], objectID: String?, completionHandler: (success: Bool, error: String?) -> Void) {
        
        var urlString = parse.baseURL
        
        if let existsObjectID = objectID {
            urlString = urlString + existsObjectID
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.addValue(parse.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(parse.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = HTTPMethod
        
        if let JSONDict = jsonifyDict(HTTPBody) {
            request.HTTPBody = JSONDict
            
            let task = session.dataTaskWithRequest(request) {data, response, error in
                if error != nil {
                    completionHandler(success: false, error: "Could not update location due to server")
                } else {
                    OTMClient.parseJSONWithCompletionHandler(data, completionHandler: {result, error in
                        if let dataResult = result as? [String: AnyObject]{
                            println("Data from server is \(dataResult)")
                            //if there is no object yet, store object information from server in variable.
                            if objectID == nil {
                                if let userObject = dataResult["objectId"] as? String {
                                    self.userObjectID = userObject
                                    completionHandler(success: true, error: nil)
                                }
                                //if the returned JSON object contains "updatedAt", update was successful
                            } else if dataResult["updatedAt"] != nil {
                                completionHandler(success: true, error: nil)
                            } else {
                                println("error in updating")
                                completionHandler(success: false, error: "False response")
                            }
                        }
                    })
                }
            }
            
            task.resume()
            
        } else {
            completionHandler(success: false, error: "Couldn't transform the HTTPBody dictionary")
        }
    }
        
}