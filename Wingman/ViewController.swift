//
//  ViewController.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/1/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginButton(sender: AnyObject) {
        
        
        
        var fieldValues: [String] = [usernameField.text, passwordField.text]
        
        if find(fieldValues, "") != nil {
            
            //all fields are not filled in
            var alertViewController = UIAlertController(title: "Submission Error", message: "Please complete all fields", preferredStyle: UIAlertControllerStyle.Alert)
            
            var defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alertViewController.addAction(defaultAction)
            
            presentViewController(alertViewController, animated: true, completion: nil)
        }
            
    
        
        else {
            
            PFUser.logInWithUsernameInBackground(usernameField.text, password:passwordField.text) {
                (user: PFUser!, error: NSError!) -> Void in
                
                
                if (user != nil) {
                    // need to go to tabBarController
                    
                    
                    
                    //all fields are filled in
                    println("All fields are filled in and login complete")
                    
                    
                    var userQuery = PFUser.query()
                    userQuery.whereKey("username", equalTo: self.usernameField.text)
                    
                    userQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        
                        if objects.count > 0 {
                            
                            self.isLoggedIn = true
                            self.checkIfLoggedIn()
                            
                        } else {
                            
//                            self.signUp()
                        }
                    })
                    
                } else {
                    if let errorString = error.userInfo?["error"] as? NSString
                    {
                        var alert:UIAlertView = UIAlertView(title: "Error", message: errorString, delegate: nil, cancelButtonTitle: "Ok")
                        
                        alert.show()
                    }
                        
                    else {
                        var alert:UIAlertView = UIAlertView(title: "Error", message: "Unable to login" , delegate: nil, cancelButtonTitle: "Ok")
                        
                        alert.show()
                        
                    }
                    
                    
                    
                }
                
            
            }
        }
    }

    
    var isLoggedIn: Bool {
        
        get {
            
            return NSUserDefaults.standardUserDefaults().boolForKey("isLoggedIn")
            
        }
        
        set {
            
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "isLoggedIn")
            
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
    }
        

    func checkIfLoggedIn(){
        
        println(isLoggedIn)
        
        if isLoggedIn {
            
            //replace this controller with the tabbarcontroller
            
            var tbc = storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
            
            println(tbc)
            
            UIApplication.sharedApplication().keyWindow?.rootViewController = tbc
            
        }
        
        
    }

  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

