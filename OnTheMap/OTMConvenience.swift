//
//  OTMConvenience.swift
//  OnTheMap
//
//  Created by Julius Danek on 25.06.15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation

extension OTMClient {
    
    func udacityLogIn (HTTPBody: [String: AnyObject], completitionHandler: (success: Bool, errorString: String?) -> Void) {
        
        // call udacity client functions, post a request and look at response. initiate handler chain and store relevant data in OTMClient
        udacitySessionPOST(HTTPBody, completitionHandler: {success, accountID, error in
            if success {
                self.accountID = accountID
                
                self.getUserData(self.accountID!, completitionHandler: {success, error in
                    if success {
                        completitionHandler(success: true, errorString: nil)
                    } else {
                        completitionHandler(success: success, errorString: error)
                    }
                })
            } else {
                completitionHandler(success: success, errorString: error)
            }
        })
    }
    
    
    
    
}