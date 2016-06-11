//
//  AllEventsViewController.swift
//  TrailBuds
//
//  Created by Jessica Wilson on 3/17/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AllEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, goBackProtocol {
    
    // MARK: Properties
    
    // This array shows all the events and is what the table view pulls data from
    var events = [String]()
    
    var trailName: String?
    var hikeLocation: String?
    var hikeDistance: String?
    var elevationGain: String?
    var eventDate: String?
    var eventID: String?
    var image_url: String?
    
    //Event
    var event: AnyObject?
    
    @IBOutlet weak var allEventsTableView: UITableView!
    
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {

        performSegueWithIdentifier("CreateEventSegue", sender: nil)
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func eventFilterButtonPressed(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
           //filter by date
            print("hi")
        case 1:
            //filter by time
            print("bye")
        default:
            break;
        }
    }
    
    // VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allEventsTableView.delegate = self
        allEventsTableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        event = nil
        getEvents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{

        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("allEventsCell", forIndexPath: indexPath) as! allEventsCell
      
        //separating data from getMessages()
        self.event = events[indexPath.row]
        let delimiter = "*"
        var token = event!.componentsSeparatedByString(delimiter)
        
        self.trailName = token[0]
        self.hikeLocation = token[1]
        self.hikeDistance = token[2]
        self.elevationGain = token[3]
        self.eventDate = token[4]
        self.eventID = token[5]
//        self.image_url = token[6]
        
        //setting event images in table view
//        let url = NSURL(string: image_url)
//        let data = NSData(contentsOfURL: url!)
//        cell.allEventsImage!.contentMode = .ScaleAspectFit
//        cell.allEventsImage!.image = UIImage(data: data!)
        
        cell.eventNameLabel!.text = trailName
        cell.locationLabel!.text = hikeLocation
        cell.lengthOfHikeLabel!.text = String("Length: \(hikeDistance!) miles")
        cell.elevationGainLabel!.text = String("Elevation Gain: \(elevationGain!) feet")
        cell.eventDateTimeLabel!.text = eventDate
        
        return cell
    }
    
    func goBack(){
        dismissViewControllerAnimated(true, completion: nil)
        allEventsTableView.reloadData()
    }
    
     //This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "CreateEventSegue"{
            let navController = segue.destinationViewController as! UINavigationController
            let controller = navController.topViewController as! CreateEventViewController
            controller.delegate = self
        }
        
        if segue.identifier == "SingleEventSegue"{
            let navController = segue.destinationViewController as! UINavigationController
            let controller = navController.topViewController as! SingleEventViewController
            controller.delegate? = self
            controller.event
                = event!
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
 
        event = events[indexPath.row]

        performSegueWithIdentifier("SingleEventSegue", sender: indexPath)
        
    }
    
    // Gets all Events and pushes the categories trailNmae, hikeLocation, hikeDistance, and eventDate into the array events
    func getEvents() {
        
        let urlString = "http://localhost:3000/events"
        //        let urlString = "http://trailbuds.org/events"
        
        events = []
        Alamofire.request(.GET, urlString).responseJSON { (response) -> Void in
            
            if let value = response.result.value {
                
                let json = JSON(value)
                
                // use SwiftyJSON
                for (index,subJson):(String, JSON) in json {
                    print(subJson)
                    self.events.append(
                        subJson["trailName"].stringValue + "*" +
                        subJson["hikeLocation"].stringValue + "*" +
                        subJson["hikeDistance"].stringValue + "*" +
                        subJson["elevationGain"].stringValue + "*" +
                        subJson["eventDate"].stringValue + "*" +
                        subJson["id"].stringValue + "*" +
                        subJson["image_url"].stringValue)
                }
            }
            self.allEventsTableView.reloadData()
        }
    }

}
