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
    var allEvents = [NSArray]()
    
    //Event info from All events page
    var eventInfo: AnyObject?
    
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
        
        eventInfo = nil
        getAllEvents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{

        return allEvents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("allEventsCell", forIndexPath: indexPath) as! allEventsCell
      
        // Pulling from Rails
        let eventInfo = allEvents[indexPath.row]
        
        cell.eventNameLabel!.text = String(eventInfo[2])
        cell.locationLabel!.text = String(eventInfo[6])
        cell.lengthOfHikeLabel!.text = String("Length: \(eventInfo[4]) miles")
        cell.eventDateTimeLabel!.text = String(eventInfo[12])
        
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
            controller.eventInfo
                = eventInfo!
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
 
        eventInfo = allEvents[indexPath.row]

        performSegueWithIdentifier("SingleEventSegue", sender: indexPath)
        
    }
    
    // Gets all Events and pushes the categories trailNmae, hikeLocation, hikeDistance, and eventDate into the array allEvents
    func getAllEvents() {
        
        let eventsJSON:String = "http://localhost:3000/eventsJSON"
        //        let eventsJSON2:String = "http://trailbuds.org/eventsJSON"
        
        allEvents = []
        Alamofire.request(.GET, eventsJSON).responseJSON { (response) -> Void in
            print(response)
            if let value = response.result.value {
                let json = JSON(value)
                
                for (index,subJson):(String, JSON) in json {
                    
                    var temporaryArray = [String]()
                    
                    temporaryArray.append(String(subJson["id"].number!))
                    // temporaryArray.append(subJson["name"].string!)
                    temporaryArray.append("Default name")
                    temporaryArray.append(subJson["trailName"].string!)
                    temporaryArray.append(subJson["meetingLocation"].string!)
                    temporaryArray.append(subJson["hikeDistance"].string!)
                    temporaryArray.append(subJson["elevationGain"].string!)
                    temporaryArray.append(subJson["hikeLocation"].string!)
                    temporaryArray.append(subJson["latitude"].string!)
                    temporaryArray.append(subJson["longitude"].string!)
                    temporaryArray.append(subJson["description"].string!)
                    temporaryArray.append(String(subJson["user_id"].number!))
                    temporaryArray.append(subJson["maxAttendees"].string!)
                    temporaryArray.append(subJson["eventDate"].string!)
                    temporaryArray.append(subJson["created_at"].string!)
                    temporaryArray.append(subJson["updated_at"].string!)
                    print(temporaryArray)
                    
                    self.allEvents.append(temporaryArray)
                    
                }
            }
            self.allEventsTableView.reloadData()
        }
    }

}
