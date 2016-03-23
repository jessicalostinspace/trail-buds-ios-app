//
//  ViewController.swift
//  TrailBuds
//
//  Created by Jessica Wilson on 3/19/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class CreateEventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    // MARK: defining parameters
    
    var delegate: goBackProtocol?
    
    var maxAttendeesPickerData: [Int] = [Int]()
    
    let ref = Firebase(url: "https://trailbuds.firebaseio.com/")
    
//    let fbID = FBSDKProfile.
//    var userID: String! { get }
    
    let realm = try! Realm()
    
    // Get Realm objects
    let users = try! Realm().objects(User)
    
    @IBOutlet weak var maxAttendeesPicker: UIPickerView!
    @IBOutlet weak var createEventScrollView: UIScrollView!
    
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
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // creating max attendees array
        for  i in 1...10{
            maxAttendeesPickerData += [i]
            print(maxAttendeesPickerData)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.maxAttendeesPicker.delegate = self
        self.maxAttendeesPicker.dataSource = self

       createEventScrollView.contentSize.height = 665
        
        
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
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
        
        //get user id from realm
         let user_id = users[0].id
        
        //save to firebase database
        let eventRef = self.ref.childByAppendingPath("events")
        let event = ["trailName": trailNameTextField.text!, "cityHikeLocation" : cityHikeLocationTextField.text!, "stateHikeLocation" : stateHikeLocationTextField.text!, "meetingLocation" : meetingLocationTextField.text!, "hikeDistance" : hikeDistanceTextField.text!, "elevationGain" : elevationGainTextField.text!, "maxAttendees" : maxAttendeesTextField.text!,"description" : descriptionTextField.text!, "createdBy" : user_id]
        
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
    
    //MARK: UIPickerView Delegate functions
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxAttendeesPickerData.count
    }
    

    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(String(maxAttendeesPickerData[row]))
        return String(maxAttendeesPickerData[row])
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

