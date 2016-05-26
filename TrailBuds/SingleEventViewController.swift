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

class SingleEventViewController: UIViewController, MKMapViewDelegate{
    
    //MARK: Attributes
    
    //day variable for weather
    var day1 = 3
    var day2 = 11
    var day3 = 19
    var day4 = 27
    var day5 = 36
    
    var latitude = ""
    var longitude = ""
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
    var eventInfo: AnyObject?
    
    @IBOutlet weak var eventMainImage: UIImageView!
    @IBOutlet weak var trailNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var elevationGainLabel: UILabel!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var hostPicture: UIImageView!
    @IBOutlet weak var forecastIconImage: UIImageView!
    @IBOutlet weak var forecastDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBAction func interestedButtonPressed(sender: UIButton) {
    }
    
    @IBAction func joinButtonPressed(sender: UIButton) {
    }
    
    @IBOutlet var collectionView: [UICollectionView]!
    

    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
        eventInfo = nil
        delegate?.goBack()
    }

    @IBOutlet weak var singleEventScrollView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singleEventScrollView.contentSize.height = 2000
        
//        getDateDifference()
//        
//        if numberOfDaysUntilEvent <= 5 {
//            getForecast(numberOfDaysUntilEvent)
//            print("finished Getting Forecast")
//            print(self.temperature)
//            print(self.weather)
//        }
//        else {
//            forecastDescriptionLabel.text = "Forecast not available"
//        }
//
//        getForecastIcon()
    
        trailNameLabel.text =  String(eventInfo![2])
        locationLabel.text = String("Location: \(eventInfo![6])")
        distanceLabel.text = String("Distance: \(eventInfo![4]) miles")
        elevationGainLabel.text = String("Elevation Gain: \(eventInfo![5]) feet")
        hostNameLabel.text = String("Host: \(eventInfo![10])")
        descriptionLabel.text = String("Description: \(eventInfo![9])")


        let latitudeString = eventInfo![7] as! String
        let longitudeString = eventInfo![8] as! String
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//                jsonDate = day1
                print("defaulted")
        }
        
        
        let latitude1 = eventInfo!.value["latitude"] as! Double
        
        latitude = String(latitude1)
        print(latitude)
        
        let longitude1 = eventInfo!.value["longitude"] as! Double
        longitude = String(longitude1)

     
        var jsonTemp: String = ""
        var jsonWeather: String = ""
        
        Alamofire.request(.GET, "http://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&&APPID=76d4052376f230c0876c8022a090ecde").responseJSON { (response) -> Void in
            
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
                    self.forecastIconImage.image = UIImage(named: "downpourIcon")
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
        
        convertedEventDate = eventInfo!.value["eventDate"] as! String
        
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        eventDate = dateFormatter.dateFromString(convertedEventDate)
        
        let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: currentDate, toDate: eventDate!, options: NSCalendarOptions.init(rawValue: 0))
        
//        print("The difference between dates is: \(diffDateComponents.year) years, \(diffDateComponents.month) months, \(diffDateComponents.day) days, \(diffDateComponents.hour) hours, \(diffDateComponents.minute) minutes, \(diffDateComponents.second) seconds")
        
        numberOfDaysUntilEvent = diffDateComponents.day
    }
    
    func getForecastIcon(){
        print(self.weather)
    }

    /*
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
