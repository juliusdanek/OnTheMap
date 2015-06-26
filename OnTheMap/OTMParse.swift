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
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, error: "Could not download data")
            } else {
                OTMClient.parseJSONWithCompletionHandler(data, completionHandler: {result, error in
                    if let dataResult = result as? [String: AnyObject] {
                        if let dataArray = dataResult["results"] as? [[String: AnyObject]] {
                            for element in dataArray {
                                //Mark: Even though student data is downloaded by date of creation, I want to make sure by double checking timestamps that I only have the most up to date info
                                let studentID = element["uniqueKey"] as! String
                                let timeStamp = OTMClient.sharedInstance().timeConversion(element["updatedAt"] as! String)
                                if let currentEntry = OTMClient.sharedInstance().studentData[studentID] {
//                                    println(timeStamp, element["updatedAt"])
//                                    println(currentEntry.updatedAtTI, currentEntry.updatedAt)
                                    if timeStamp > currentEntry.updatedAtTI {
                                        let studentObject = StudentInformation(studentDict: element)
                                        OTMClient.sharedInstance().studentData[studentID] = studentObject
//                                        println("student location updated!")
                                    } else {
//                                        println("student location was older")
                                    }
                                } else {
                                    let studentObject = StudentInformation(studentDict: element)
                                    OTMClient.sharedInstance().studentData[studentID] = studentObject
//                                    println("new student added")
                                }
//                                println(OTMClient.sharedInstance().studentData)
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
    
    
}