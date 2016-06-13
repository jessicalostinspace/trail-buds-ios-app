//
//  ViewController.swift
//  TrailBuds
//
//  Created by Jessica Wilson on 3/19/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class CreateEventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate, LocateOnTheMap {
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    // this variable is used to enter the information in the database
    var maxAttendeesPickerDataFinal: Int?
    
    // MARK: defining parameters
    
    var delegate: goBackProtocol?
    
    @IBOutlet weak var myDatePicker: UIDatePicker!
    var maxAttendeesPickerData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    var strDate: String?
    
    // location information
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    var longitude: Double?
    var latitude: Double?
    var location: String?
    
    @IBOutlet weak var locationLabel: UILabel!
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
    @IBOutlet weak var locationButton: UIButton!
    
    @IBAction func datePickerSelected(sender: AnyObject) {

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        strDate = dateFormatter.stringFromDate(myDatePicker.date)
    }
    
    @IBAction func locationButtonPressed(sender: UIButton) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.maxAttendeesPicker.delegate = self
        self.maxAttendeesPicker.dataSource = self
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        
        createEventScrollView.contentSize.height = 669
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
        
        //gets facebook user id from NSUserDefaults
        let user_id2 = prefs.stringForKey("user_id")
        let user_name = prefs.stringForKey("user_name")

        //================================================
        // Adding to Rails
        let endPoint: String = "https://trailbuds.herokuapp.com/events"
        let endPoint2: String = "http://trailbuds.org/events"
        let endPoint3: String = "http://localhost:3000/events"
        
        let parameters = [
            "trailName": trailNameTextField.text!,
            "meetingLocation" : meetingLocationTextField.text!,
            "hikeDistance" : hikeDistanceTextField.text!,
            "elevationGain" : elevationGainTextField.text!,
            "description" : descriptionTextField.text!,
            "hikeLocation" : String(location!),
            "latitude" : String(latitude!),
            "longitude": String(longitude!),
            "maxAttendees": String(self.maxAttendeesPickerDataFinal!),
            "eventDate": strDate!,
            "facebook_id" : String(user_id2!),
        ]
        
        Alamofire.request(.POST, endPoint3, parameters: parameters, encoding: .JSON)
            .responseString { response in
                // print response as string for debugging, testing, etc.
                print(response.result.value)
                print(response.result.error)
                self.delegate?.goBack()
        }
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
        return String(maxAttendeesPickerData[row])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        maxAttendeesPickerDataFinal = maxAttendeesPickerData[row]
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
            self.searchResultController.reloadDataWithArray(self.resultsArray)
        }
    }
    
    //Locate map with longitude and latitude after search location on UISearchBar
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            self.longitude = lon
            self.latitude = lat
            self.location = title
            self.locationButton.setTitle(title, forState: .Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

