//
//  AllEventsViewController.swift
//  TrailBuds
//
//  Created by Jessica Wilson on 3/17/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON

class AllEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, goBackProtocol {
    
    // MARK: Properties
    
    // This array shows all the events and is what the table view pulls data from
    var allEvents = [NSArray]()
    
    
    // your firebase reference as a property
    var ref: Firebase!
    var events = [FDataSnapshot]()
    var eventInfo: AnyObject?
    
    var hikeLocation: String?
    
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
        }    }
    
    
    
    // Gets all Events and pushes the categories trailNmae, hikeLocation, hikeDistance, and eventDate into the array allEvents
    
    func getAllEvents() {
        
        let eventsJSON:String = "http://localhost:3000/eventsJSON"
        let eventsJSON2:String = "http://trailbuds.org/eventsJSON"
        
        allEvents = []
        Alamofire.request(.GET, eventsJSON).responseJSON { (response) -> Void in
            print(response)
            if let value = response.result.value {
                let json = JSON(value)
                
                for (index,subJson):(String, JSON) in json {
                    
                    var temporaryArray = [String]()
                    
                    temporaryArray.append(String(subJson["id"].number!))
                    
                    //                    temporaryArray.append(subJson["name"].string!)
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
//                    temporaryArray.append("Default date")
                    
                    temporaryArray.append(subJson["created_at"].string!)
                    temporaryArray.append(subJson["updated_at"].string!)
                    print(temporaryArray)
                    
                    self.allEvents.append(temporaryArray)
                    
                    
                }
            }
            self.allEventsTableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allEventsTableView.delegate = self
        allEventsTableView.dataSource = self
        
        getAllEvents()
        
        // initialize firebase ref
        ref = Firebase(url:"https://trailbuds.firebaseio.com/events")
    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        eventInfo = nil

        
         //listen for update with the .Value event
        ref.observeEventType(.Value) { (snapshot: FDataSnapshot!) in
            
            var newEvents = [FDataSnapshot]()
            
            // loop through the children and append them to the new array
            for event in snapshot.children {
                newEvents.append(event as! FDataSnapshot)
            }

            // replace the old array
            self.events = newEvents
            print(self.events)
            // reload the UITableView
            self.allEventsTableView.reloadData()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //change this to .count
//        return events.count
        print("=============")
        print("=============")
        print("=============")
        print(allEvents.count)
        print("=============")
        print("=============")
        print("=============")
        return allEvents.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("allEventsCell", forIndexPath: indexPath) as! allEventsCell
//        cell.allEventsImage.image =//something
        
//        let eventInfo = events[indexPath.row]
//        
//        var hikeDistance = eventInfo.value["hikeDistance"] as! String
//        var eventDate = eventInfo.value["eventDate"] as! String
//
//        cell.eventNameLabel!.text = eventInfo.value["trailName"] as! String
//        cell.locationLabel!.text = eventInfo.value["hikeLocation"] as! String
//        cell.lengthOfHikeLabel!.text = ("\(hikeDistance) miles")
//        cell.eventDateTimeLabel!.text = eventDate
      
        // Pulling from Rails
        let eventInfo = allEvents[indexPath.row]
        
        print("=================")
        print("=================")
        print(eventInfo)
        print("=================")
        print("=================")
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
