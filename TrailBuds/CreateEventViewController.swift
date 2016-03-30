//
//  ViewController.swift
//  TrailBuds
//
//  Created by Jessica Wilson on 3/19/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

class CreateEventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate, LocateOnTheMap {
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    // this variable is used to enter the information in the database
    var maxAttendeesPickerDataFinal: Int?
    
    
    // MARK: defining parameters
    
    var delegate: goBackProtocol?
    
    var maxAttendeesPickerData: [Int] = [Int]()
    
    let ref = Firebase(url: "https://trailbuds.firebaseio.com/")
    
//    let fbID = FBSDKProfile.
//    var userID: String! { get }
    
    
    @IBOutlet weak var maxAttendeesPicker: UIPickerView!
    @IBOutlet weak var createEventScrollView: UIScrollView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var trailNameTextField: UITextField!

    @IBOutlet weak var meetingLocationTextField: UITextField!
    @IBOutlet weak var hikeDistanceTextField: UITextField!
    @IBOutlet weak var elevationGainTextField: UITextField!
    @IBOutlet weak var maxAttendeesTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBAction func datePickerSelected(sender: AnyObject) {
//        var chosenDate = self.datePicker.date
        
        
        //need to create outlet from datePicker called myDatePicker, type is UIDatePicker
        
//        var dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
//        var strDate = dateFormatter.stringFromDate(myDatePicker.date)
        
    }
    
    // location information
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    var longitude: Double?
    var latitude: Double?
    var location: String?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
    
    }
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBAction func locationButtonPressed(sender: UIButton) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    // searchbar when text change
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let placeClient = GMSPlacesClient()
        placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil){
            (results, error: NSError?) -> Void in
            
            self.resultsArray.removeAll()
            if results == nil {
                return
            }
            
            for result in results! {
                if let result = result as? GMSAutocompletePrediction{
                    self.resultsArray.append(result.attributedFullText.string)
                }
            }
            print(results)
            
            self.searchResultController.reloadDataWithArray(self.resultsArray)
        }
    }
    
    //Locate map with longitude and latitude after search location on UISearchBar
    
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            print(lon)
            self.longitude = lon
            self.latitude = lat
            self.location = title
            print(lat)
            print(title)
            self.locationLabel.text = title
            
            
        }
    }
    
    //----------------------------
    //----------------------------
    
    
    
    
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

       createEventScrollView.contentSize.height = 669
        
        
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
        
        //gets facebook user id from NSUserDefaults
        let user_id2 = prefs.stringForKey("user_id")
        
        //save to firebase database
        let eventRef = self.ref.childByAppendingPath("events")
        let event = ["trailName": trailNameTextField.text!, "meetingLocation" : meetingLocationTextField.text!, "hikeDistance" : hikeDistanceTextField.text!, "elevationGain" : elevationGainTextField.text!,
            "hikeLocation" : location!, "latitude" : latitude!, "longitude": longitude!,"description" : descriptionTextField.text!, "createdBy" : user_id2!, "maxAttendees": self.maxAttendeesPickerDataFinal!]
        
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
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        maxAttendeesPickerDataFinal = maxAttendeesPickerData[row]
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

