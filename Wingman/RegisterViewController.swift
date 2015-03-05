//
//  RegisterViewController.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/2/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let segments = ["Male", "Female"]
    
    @IBAction func pickImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    @IBOutlet weak var pickedImage: UIImageView!
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        pickedImage.image = image
    }
   
    
  
    
    
    @IBOutlet weak var createUsernameField: UITextField!
    
    @IBOutlet weak var enterEmailField: UITextField!
    
    @IBOutlet weak var createPasswordField: UITextField!
    
    @IBAction func genderSC(sender: UISegmentedControl) {
        
        var segmentedControl: UISegmentedControl!
        let selectedSegmentIndex = sender.selectedSegmentIndex
        
        let selectedSegmentText = sender.titleForSegmentAtIndex(selectedSegmentIndex)
        
        let segments = ["Male", "Female"]
        
        segmentedControl = UISegmentedControl(items: segments)
        
        segmentedControl.addTarget(self, action: "segmentedControlValueChanged:", forControlEvents: .ValueChanged)
        
        
        println("Segment \(selectedSegmentIndex) with text of" + " \(selectedSegmentText) is selected")
        
    }
    
    @IBOutlet weak var interestField: UITextField!
    
    @IBAction func signUp(sender: AnyObject) {
        
        
        var user = PFUser()
        user.username = createUsernameField.text
        user.password = createPasswordField.text
        user.email = enterEmailField.text
        
        //how to take results from func genderSC and put it here?
      
       // user["gender"] = String(genderSC(UISegmentedControl(items: segments)))
        
        //how to save a pic in Parse?
        //user["profile pic"] =
       //user["interests"] = interestField[] or .text
        
        // other fields can be set just like with PFObject
        //user["phone"] = "415-392-0202"
        
        var fieldValues: [String] = [createUsernameField.text, createPasswordField.text, enterEmailField.text] //interestField.text
        
        if find(fieldValues, "") != nil {
            
            //all fields are not filled in
            var alertViewController = UIAlertController(title: "Submission Error", message: "Please complete all fields", preferredStyle: UIAlertControllerStyle.Alert)
            
            var defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alertViewController.addAction(defaultAction)
            
            presentViewController(alertViewController, animated: true, completion: nil)
        }
            
        else {
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool!, error: NSError!) -> Void in
                if error == nil {
                    // Hooray! Let them use the app now.
                    
                    println(user)
                    
                    self.createUsernameField.text = ""
                    self.createPasswordField.text = ""
                    self.enterEmailField.text = ""
                    //self.interestField.text = ""
                   // self.genderSC(sender: UISegmentedControl(items: segments)) = ""
                    
                    
                }
                else
                {
                    if let errorString = error.userInfo?["error"] as? NSString
                    {
                        var alert:UIAlertView = UIAlertView(title: "Error", message: errorString, delegate: nil, cancelButtonTitle: "Ok")
                        
                        alert.show()
                    }
                        
                    else {
                        var alert:UIAlertView = UIAlertView(title: "Error", message: "Unable to create account" , delegate: nil, cancelButtonTitle: "Ok")
                        
                        alert.show()
                        
                    }
                    
                    
                }
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
