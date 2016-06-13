//
//  SingleEventViewController.swift
//  TrailBuds
//
//  Created by Jessica Wilson on 3/17/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import Alamofire

class SingleEventViewController: UIViewController, MKMapViewDelegate, UITextViewDelegate{
    
    //MARK: Attributes
    var eventID: String?
    var trailName: String = ""
    var hikeLocation: String = ""
    var hikeDistance: String = ""
    var elevationGain: String = ""
    var event_image_url: String = ""
    var eventDescription: String = ""
    var hostName: String = ""
    //currently logged in user
    var userID: String = ""
    var attendeesArray = [String]()
    
    //day variable for weather
    var day1 = 3
    var day2 = 11
    var day3 = 19
    var day4 = 27
    var day5 = 36
    
    var latitudeString = ""
    var longitudeString = ""
    var temperature: Double?
    var weather = ""
    
    var currentDate = NSDate()
    var convertedCurrentDate: String = ""
    var convertedEventDate: String = ""
    var numberOfDaysUntilEvent = 0
    var eventDate: NSDate? = nil
    let dateFormatter = NSDateFormatter()
    var dateAsString: String = ""
    
    var delegate: goBackProtocol?
    var event: AnyObject?
    
    @IBOutlet weak var eventMainImage: UIImageView!
    @IBOutlet weak var trailNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var elevationGainLabel: UILabel!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var hostPicture: UIImageView!
    @IBOutlet weak var forecastIconImage: UIImageView!
    @IBOutlet weak var forecastDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet var collectionView: [UICollectionView]!
    @IBOutlet weak var singleEventScrollView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLayoutSubviews() {
        singleEventScrollView.contentSize.height = 2000
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.delegate = self
        
        trailNameLabel.text =  trailName
        locationLabel.text = String("Location: \(hikeLocation)")
        distanceLabel.text = String("Distance: \(hikeDistance) miles")
        elevationGainLabel.text = String("Elevation Gain: \(elevationGain) feet")
        hostNameLabel.text = String("Host: \(hostName)")
//        descriptionLabel.text = String("Description: \(eventDescription)")

        getDateDifference()
        print(numberOfDaysUntilEvent)
        
        if numberOfDaysUntilEvent <= 4 && numberOfDaysUntilEvent >= 0 {
            getForecast(numberOfDaysUntilEvent)
            print("finished Getting Forecast")
            print(self.temperature)
            print(self.weather)
        }
        else {
            forecastDescriptionLabel.text = "Forecast not available"
        }
        
        let latitudeAsDouble = Double(latitudeString)
        let longitudeAsDouble = Double(longitudeString)

        let longitude = CLLocationDegrees(longitudeAsDouble!)
        let latitude = CLLocationDegrees(latitudeAsDouble!)

        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        self.mapView.addAnnotation(annotation)
        self.mapView.setRegion(region, animated: true)

    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        event = nil
        delegate?.goBack()
    }
    
    @IBAction func interestedButtonPressed(sender: UIButton) {
    }
    
    @IBAction func joinButtonPressed(sender: UIButton) {
        addUserToAttendees()
//        collectionView.
    }
    
    func getForecast(daysUntilEvent: Int){
        
        var jsonDate = 0
        print("days until event")
        print(daysUntilEvent)
        switch daysUntilEvent {
            case 0:
                jsonDate = day1
            case 1:
                jsonDate = day2
            case 2:
                jsonDate = day3
            case 3:
                jsonDate = day4
            case 4:
                jsonDate = day5
            default:
                print("defaulted")
        }
     
        var jsonTemp: String = ""
        var jsonWeather: String = ""
        
        Alamofire.request(.GET, "http://api.openweathermap.org/data/2.5/forecast?lat=\(latitudeString)&lon=\(longitudeString)&&APPID=76d4052376f230c0876c8022a090ecde").responseJSON { (response) -> Void in

            if let value = response.result.value {
 
                let json = JSON(value)

                // use SwiftyJSON
                for (key,subJson):(String, JSON) in json {
                    
                    if key == "list" {
//                        let date = subJson[jsonDate]["dt_txt"].stringValue
                        jsonTemp = String(subJson[jsonDate]["main"]["temp"])
                        jsonWeather = subJson[jsonDate]["weather"][0]["description"].stringValue
                    }
                }// End for loop
                
            }//End if response
            
            let temp = Double(jsonTemp)
            
            self.temperature = temp! * (9/5) - 459.67
            self.weather = jsonWeather
            
            self.forecastDescriptionLabel.text = "\(self.temperature!.format(".2"))°F  \(self.weather)"
            
            switch self.weather {
                
                case "light rain":
                    self.forecastIconImage.image = UIImage(named: "lightRain")
                    print("got here")
                case "clear sky":
                    self.forecastIconImage.image = UIImage(named: "sunIcon")
                case "scattered clouds":
                    self.forecastIconImage.image = UIImage(named: "partlyCloudyIcon")
                case "broken clouds":
                    self.forecastIconImage.image = UIImage(named: "partlyCloudyIcon")
                case "few clouds":
                    self.forecastIconImage.image = UIImage(named: "partlyCloudyIcon")
                case "overcast clouds":
                    self.forecastIconImage.image = UIImage(named: "overcast")
                case "moderate rain":
                    self.forecastIconImage.image = UIImage(named: "moderateRain")
                case "light snow":
                    self.forecastIconImage.image = UIImage(named: "snowflakeIcon")
                default:
                    print("defaulted icon image")
                    self.forecastIconImage.image = UIImage(named: "partlyCloudyIcon")
            }
            
        }// End API HTTP request

    }
    
    func getDateDifference(){
        
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        eventDate = dateFormatter.dateFromString(convertedEventDate)
        
        let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: currentDate, toDate: eventDate!, options: NSCalendarOptions.init(rawValue: 0))
        
//        print("The difference between dates is: \(diffDateComponents.year) years, \(diffDateComponents.month) months, \(diffDateComponents.day) days, \(diffDateComponents.hour) hours, \(diffDateComponents.minute) minutes, \(diffDateComponents.second) seconds")
        
        numberOfDaysUntilEvent = diffDateComponents.day
    }
    
    //function gets event info from rails
    func getEvent() {
        
        let urlString = "http://localhost:3000/events/\(eventID!)/"
        
        Alamofire.request(.GET, urlString).responseJSON { (response) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    self.trailName = String(json["trailName"])
                    self.hikeLocation = String(json["hikeLocation"])
                    self.hikeDistance = String(json["hikeDistance"])
                    self.elevationGain = String(json["elevationGain"])
                    self.event_image_url = String(json["image_url"])
                    self.latitudeString = String(json["latitude"])
                    self.longitudeString = String(json["longitude"])
                    self.eventDescription = String(json["description"])
                    self.convertedEventDate = String(json["eventDate"])
                    self.hostName = String(json["host_name"])
                    
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func addUserToAttendees(){
        let prefs = NSUserDefaults.standardUserDefaults()
        
        if let id = prefs.stringForKey("user_id"){
            self.userID = id
        }
        
        //SAVING message to rails database
        let parameters = [
            "facebook_id": self.userID,
            "event_id": eventID!,
            ]
        
        let urlString = "http://localhost:3000/attendees"
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON)
            .responseString { response in
                // print response as string for debugging, testing, etc.
                print(response.result.error)
                print("added attendee to database!")
        }

    }
    
    // MARK: Text View Delegate Methods
    
    func textViewDidEndEditing(textView: UITextView){
        
        eventDescription = descriptionTextView.text!
        
        let updateParameters = [
            "description": descriptionTextView.text!
        ]
        
        let updateLink = "http://localhost:3000/events/\(eventID!)"
        //        let updateLink2 = "http://trailbuds.org/users/\(facebook_id)"
        Alamofire.request(.PATCH, updateLink, parameters: updateParameters, encoding: .JSON)
            .responseString { response in
                // print response as string for debugging, testing, etc.
                print(response.result.error)
                
        }
    }
    
    func textViewDidChange(textView: UITextView){
        
    }
    
    // MARK: Collection View Delegate Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
//        return attendeesArray.count - 1
        return 1
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AttendeesCell", forIndexPath: indexPath) as! AttendeesCollectionViewCell
        
        cell.backgroundColor = UIColor.blackColor()
        
//        let currImage = self.colorData[indexPath.row]
//        
//        cell.imageView.image = UIImage(named: currImage)
//        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
//        color = colorData[indexPath.row]
//        performSegueWithIdentifier("ColorToWildlifeSegue", sender: indexPath)
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    /*
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
