//
//  NavControllerVC.swift
//  OnTheMap
//
//  Created by Julius Danek on 25.06.15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation
import UIKit


class TabBarSetup: UITabBarController {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var firstButton = UIBarButtonItem(image: UIImage(named: "location"), style: UIBarButtonItemStyle.Plain, target: self, action: "addLocation")
        var secondButton = UIBarButtonItem(image: UIImage(named: "sync"), style: UIBarButtonItemStyle.Plain, target: self, action: "syncButton")
        
        self.navigationItem.rightBarButtonItems = [secondButton, firstButton]
    }
    
        
    @IBAction func LogOut(sender: UIBarButtonItem) {
        
        //instantiate logout alert
        var alert = UIAlertController(title: "Logout", message: "Do you want to logout?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        //add logout option
        alert.addAction(UIAlertAction(title: "Logout", style: UIAlertActionStyle.Destructive, handler: {action in
            // if it was facebook, log out of facebook
            if OTMClient.sharedInstance().FBLogin {
                OTMClient.sharedInstance().facebookLogout()
                self.dismissViewControllerAnimated(true, completion: nil)
                println("FB Logout")
            } else {
                //else logout with udacity
                OTMClient.sharedInstance().udacityLogout()
                self.dismissViewControllerAnimated(true, completion: nil)
                println("UD Logout")
            }
        }))
        
        //cancel option
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    
    }
    
    func syncButton () {
        OTMClient.sharedInstance().parseGet({success, error in
            //TODO: Present alertview in case download / update fails
            if success {
                let dataReloaded = NSNotification(name: "syncButton", object: nil)
                NSNotificationCenter.defaultCenter().postNotification(dataReloaded)
            } else {
                let alert = UIAlertController(title: "Refresh failure", message: error, preferredStyle: UIAlertControllerStyle.Alert) as UIAlertController
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    func addLocation () {
        performSegueWithIdentifier("showAddLocation", sender: nil)
        if OTMClient.sharedInstance().userObjectID == nil {
//            OTMClient.sharedInstance().parseDelete()
            OTMClient.sharedInstance().parseGetObjectId({ (success, objectID) -> Void in
                if success {
                    OTMClient.sharedInstance().userObjectID = objectID
                    println("object id is \(OTMClient.sharedInstance().userObjectID)")
                }
            })
        }
    }
    

}