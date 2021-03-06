//
//  ViewController.swift
//  OnTheMap
//
//  Created by Julius Danek on 24.06.15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LogInVC: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var facebookLogin: FBSDKLoginButton!
    @IBOutlet weak var loginButton: UIButton!
    
    func hide () {
        emailText.hidden = true
        passwordText.hidden = true
        facebookLogin.hidden = true
        loginButton.hidden = true
    }
    
    func show () {
        emailText.hidden = false
        passwordText.hidden = false
        facebookLogin.hidden = false
        loginButton.hidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            hide()
        } else {
            show()
        }
    }
    
    //allow to enter info by keyboard only
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailText {
            textField.resignFirstResponder()
            passwordText.becomeFirstResponder()
        } else if textField == passwordText {
            loginButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailText.delegate = self
        passwordText.delegate = self
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
            hide()
            
            errorLabel.text = "Logging in with Facebook..."
            
            let body: [String: AnyObject] = ["facebook_mobile": ["access_token" : FBSDKAccessToken.currentAccessToken().tokenString]]
            
            OTMClient.sharedInstance().udacityLogIn(body, completitionHandler: {success, error in
                if success {
                    // if login successful, perform segue
                    self.completeLogin(true)
                } else {
                    // else display error message with error from handler (whether bad network or credentials)
                    self.displayError(error)                    
                }
                
            })
            // User is already logged in, do work such as go to next view controller.
        } else {
            facebookLogin.readPermissions = ["public_profile", "email", "user_friends"]
            facebookLogin.delegate = self
        }

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logIn(sender: AnyObject) {
        
        self.errorLabel.text = "Attempting to login..."
        
        let body: [String : AnyObject] = ["udacity": ["username" : emailText.text, "password" : passwordText.text]]

        OTMClient.sharedInstance().udacityLogIn(body, completitionHandler: {success, error in
            if success {
                // if login successful, perform segue
                self.completeLogin(false)
            } else {
                // else display error message with error from handler (whether bad network or credentials)
                self.displayError(error)
            }
            
        })
        
    }
    
    //complete login
    func completeLogin(FB: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            self.errorLabel.text = ""
            if FB {
                OTMClient.sharedInstance().FBLogin = true
            }
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("main") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            self.show()
            self.errorLabel.text = ""
            if let errorString = errorString {
                //instantiate alert View
                var alertView = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                //add dismissal
                alertView.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: {alterView in
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }))
                //present alert view
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        })
    }
    
    //MARK: Facebook Login
    func loginButton(loginButton: FBSDKLoginButton!,
        didCompleteWithResult result: FBSDKLoginManagerLoginResult!,
        error: NSError!) {
            println("User Logged In")
            
            if ((error) != nil)
            {
                println("facebook error")// Process error
            } else if result.isCancelled {
                // Handle cancellations
            } else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if result.grantedPermissions.contains("email"){
                    
                    self.errorLabel.text = "Logging in with Facebook..."
                        
                    hide()

                    let body: [String: AnyObject] = ["facebook_mobile": ["access_token" : FBSDKAccessToken.currentAccessToken().tokenString]]
                    
                    OTMClient.sharedInstance().udacityLogIn(body, completitionHandler: {success, error in
                        if success {
                            // if login successful, perform segue
                            self.completeLogin(true)
                        } else {
                            // else display error message with error from handler (whether bad network or credentials)
                            self.displayError(error)
                        }
                        
                    })
                    
                }
            }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }

}

