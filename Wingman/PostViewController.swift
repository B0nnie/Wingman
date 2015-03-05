//
//  PostViewController.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/4/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var postData = [String:AnyObject]()
    
    @IBOutlet weak var pickerClubBar: UIPickerView!
    
    
    @IBOutlet weak var genderSwitch: UISwitch!
    
    
    @IBOutlet weak var startTime: UITextField!
    
    
    @IBOutlet weak var endTime: UITextField!
    
    @IBAction func submitPostButton(sender: AnyObject) {
        
        if postData["clubOrBar"] != nil && startTime.text != "" && endTime.text != ""
            
        {
            
            postData["startTime"] = startTime.text.toInt()
            
            postData["endTime"] = endTime.text.toInt()
            
            var query = PFQuery(className:"_User")
            
            query.whereKey("objectId", equalTo: PFUser.currentUser().objectId)
            
            
            
            query.findObjectsInBackgroundWithBlock() {
                (objects:[AnyObject]!, error:NSError!)->Void in
                
                var user = objects.last as PFUser
                
                user["postData"] = self.postData
                
                user.saveInBackground()
                
                var alertViewController = UIAlertController(title: "Post Submitted!", message: "Back to browsing", preferredStyle: UIAlertControllerStyle.Alert)
                
                var defaultAction = UIAlertAction(title: "OK", style: .Default, handler: {() -> Void in
                    
                    self.goToBrowseTableVC()
                  
                    })
        
                
                alertViewController.addAction(defaultAction)
                
                        presentViewController(alertViewController, animated: true, completion: nil) }
                
//                self.goToBrowseTableVC()
                
                
            }
        }
            
        else {
            
            var alertViewController = UIAlertController(title: "Submission Error", message: "Please complete all fields", preferredStyle: UIAlertControllerStyle.Alert)
            
            var defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alertViewController.addAction(defaultAction)
            
            presentViewController(alertViewController, animated: true, completion: nil)
            
        }
        
        
        
    }

    
    func goToBrowseTableVC() {
        
        //this takes us to Browser after post button is pushed and info has been successfully sent to parse
        
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc = storyboard.instantiateViewControllerWithIdentifier("BrowseTVC") as BrowseTableViewController
        
        self.presentViewController(vc, animated: true, completion: nil)
        
        
//
//        self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("view2") as UIViewController, animated: true)
        
        
    }
    
    
    //array of clubs/bars in Atl needs to be pulled from foursquare API to populate pickerview
    var clubsAndBarsList = ["10 High", "Ambiance", "Bar One"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pickerClubBar.dataSource = self
         pickerClubBar.delegate = self
        
        postData["gender"] = "female"
         genderSwitch.addTarget(self, action: "switchIsChanged:", forControlEvents: .ValueChanged)

        
    }
    
    
    //function letting us know which gender user chose and sending dictionary to Vedeka's database
    func switchIsChanged(sender: UISwitch){
        
        println("Sender is = \(sender)")
        
        if genderSwitch.on{
            
            postData["gender"] = "male"
            
            println("The switch is turned to male")
            
            
        } else {
            
            postData["gender"] = "female"
            
            println("The switch is turned to female")
        }
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        if pickerView == pickerClubBar {
            
            return 1
            
        }
        
        return 0
        
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerClubBar {
            
            return clubsAndBarsList.count
        }
        
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return clubsAndBarsList[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            
            var clubOrBar = clubsAndBarsList[row]
            
            //this creates the club/bar dictionary choice
            postData ["clubOrBar"] = clubOrBar
        
        println("\(row)")
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
