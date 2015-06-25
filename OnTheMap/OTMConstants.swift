//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by Julius Danek on 24.06.15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation

extension OTMClient {
    
    struct parse {
        
        //MARK: Parse
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        
    }
    
    struct udacity {
        
        struct constants {
            
            static let FBAppID = "365362206864879"
            static let baseURL = "https://www.udacity.com/api/"
        }
        
        struct methods {
            
            static let session = "session"
            static let getUserData = "users/"
        }
        
        struct JSONResponseKeys {
            
            static let accountKey = "key"
            static let account = "account"
            static let lastName = "last_name"
            static let firstName = "first_name"
            static let user = "user"
            
        }
        
    }
    
}