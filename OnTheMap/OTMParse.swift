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
    
    //This function has been set up in a way that the user only ever manipulates one object in the parse database. When loading the location addVC, the app checks whether a entry already exists in the database for the user. If it does, it uses that users object ID. If it doesn't, it creates an object ID with the first posting and then uses the received object ID later on for next postings. This does not really work when there already are several entries with an account ID but I am assuming that everybody would use this app. 
    
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
    
    //this function only gets called at the beginning of the app, when no objectID for the account has yet been done. This way, the user always only manipulates on object ID.
    func parseGetObjectId (completionHandler: (success: Bool, objectID: String?) -> Void) {
        let urlString = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(OTMClient.sharedInstance().accountID!)%22%7D"
        
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.addValue(parse.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(parse.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")

        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil {
                completionHandler(success: false, objectID: nil)
            } else {
                OTMClient.parseJSONWithCompletionHandler(data, completionHandler: {result, error in
                    if let dataResult = result as? [String: AnyObject]{
                        if let dataArray = dataResult["results"] as? [[String: AnyObject]]  {
//                            println("DataArray from server is \(dataArray)")
                            if dataArray.count != 0 {
                                if let object = dataArray[0]["objectId"] as? String {
                                    completionHandler(success: true, objectID: object)
                                }
                            }
                        }
                    }
                })
            }
        }
        
        task.resume()
    }
    
    //MARK: Used this method to delete some of my older entries
//    func parseDelete () {
//        let urlString = "https://api.parse.com/1/classes/StudentLocation/r2Qcro0xXj"
//        let url = NSURL(string: urlString)
//        let request = NSMutableURLRequest(URL: url!)
//        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        request.HTTPMethod = "DELETE"
//        
//        let task = session.dataTaskWithRequest(request) { data, response, error in
//            
//            if error != nil { /* Handle error */ return }
//            
//            println(NSString(data: data, encoding: NSUTF8StringEncoding))
//            
//        }
//        
//        task.resume()
//
//    }
    
}