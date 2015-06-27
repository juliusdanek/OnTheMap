//
//  TableView.swift
//  OnTheMap
//
//  Created by Julius Danek on 26.06.15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation
import UIKit

class TableView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTableView", name: "syncButton", object: nil)
    }
    
//    override func syncButton() {
//        super.syncButton()
//        tableView.reloadData()
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTMClient.sharedInstance().studentData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) as! UITableViewCell
        let student = OTMClient.sharedInstance().studentData[indexPath.row]
        
        cell.textLabel?.text = (student.firstName! + " " + student.lastName!)
        cell.detailTextLabel?.text = student.mediaURL
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let student = OTMClient.sharedInstance().studentData[indexPath.row]
        
        //check whether the string is actually a URL at all or just gibberish
        if let url = student.mediaURL {
            if let safariURL = NSURL(string: url) {
                UIApplication.sharedApplication().openURL(safariURL)
            }
        }
        
    }
    
    
    //update the table view. Works with a notification from the sync button. Putting reload into the main queue, as in the sync button the data download is in main queue
    func updateTableView () {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
        println("TableView Updated")
    }
    
}
