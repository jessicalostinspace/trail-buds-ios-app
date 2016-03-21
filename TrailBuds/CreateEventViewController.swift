//
//  ViewController.swift
//  TrailBuds
//
//  Created by Jessica Wilson on 3/19/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//

import UIKit
import Firebase

class CreateEventViewController: UIViewController{
    
    let ref = Firebase(url: "https://trailbuds.firebaseio.com/")
    
//    let fbID = FBSDKProfile.
//    var userID: String! { get }

    
    var delegate: goBackProtocol?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var trailNameTextField: UITextField!
    @IBOutlet weak var cityHikeLocationTextField: UITextField!
    @IBOutlet weak var stateHikeLocationTextField: UITextField!
    @IBOutlet weak var meetingLocationTextField: UITextField!
    @IBOutlet weak var hikeDistanceTextField: UITextField!
    @IBOutlet weak var elevationGainTextField: UITextField!
    @IBOutlet weak var maxAttendeesTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBAction func datePickerSelected(sender: AnyObject) {
//        var chosenDate = self.datePicker.date
        print(sender)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        trailNameTextField.delegate = self
//        cityHikeLocationTextField.delegate = self
//        stateHikeLocationTextField.delegate = self
//        meetingLocationTextField.delegate = self
//        hikeDistanceTextField.delegate = self
//        elevationGainTextField.delegate = self
//        maxAttendeesTextField.delegate = self
//        descriptionTextField.delegate = self
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
//        let parameters = ["fields" : "id"]
//        
//        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler { (connection, result, error) -> Void in
//                if error != nil {
//                    print(error)
//                    return
//            }
//            
//            
//            
//            
//            
//            }).resume()
//        }
//    
//    
//                
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
        
        //save to database
        var eventRef = self.ref.childByAppendingPath("events")
        var event = ["trailName": trailNameTextField.text!, "cityHikeLocation" : cityHikeLocationTextField.text!, "stateHikeLocation" : stateHikeLocationTextField.text!, "meetingLocation" : meetingLocationTextField.text!, "hikeDistance" : hikeDistanceTextField.text!, "elevationGain" : elevationGainTextField.text!, "maxAttendees" : maxAttendeesTextField.text!,"description" : descriptionTextField.text!, "createdBy" : "Jessica Wilson"]
        
        let eventsRef = eventRef.childByAutoId()
        eventsRef.setValue(event)
        
        delegate?.goBack()
    }
    
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        
        delegate?.goBack()
    }
    
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func fetchProfile(){
        
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), gender, location, birthday"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil{
                print(error)
                return
            }
            
    
            
            let email = result["email"] as? String
            let firstName = result["first_name"] as? String
            let lastName = result["last_name"] as? String
            let location = result["location"] as? String
            let gender = result["gender"] as? String
            let id = result["id"] as? String

            
            var pictureUrl = ""
            
            if let picture = result["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary, url = data["url"] as? String {
                pictureUrl = url
            }
            
            
            let url = NSURL(string: pictureUrl)
            NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print(error)
                    return
                }
                
                let image = UIImage(data: data!)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.profilePicture.image = image
                })
                
            }).resume()
            
        }
        
        
        //=========================================================
        
        
        
        
        //=========================================================
        

}

    // MARK: UITextFieldDelegate
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool{
//        // Hide the keyboard.
//        textField.resignFirstResponder()
//        return true
//    }
//    
//    func textFieldDidEndEditing(textField: UITextField){
//        
//        //The first line calls checkValidMealName() to check if the text field has text in it, which enables the Save button if it does. The second line sets the title of the scene to that text.
//        checkValidTopicName()
////        navigationItem.title = textField.text
//        
//    }
//    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        // Disable the Save button while editing.
//        saveButton.enabled = false
//    }
//    
//    func checkValidTopicName() {
//        // Disable the Save button if the text field is empty.
//        
//        let trailNameText = trailNameTextField.text ?? ""
//
//        
//        saveButton.enabled = !trailNameText.isEmpty
////        saveButton.enabled = !hikeLocationText.isEmpty
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

