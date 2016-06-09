//
//  MessagesViewController.swift
//  TrailBuds
//
//  Created by Jessica Wilson on 3/17/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var messages = [String]()
    var senderName: String?
    var lastReceivedMessageTime: NSDate?
    var pictureUrl: String?
    var firstName: String?
    var lastName: String?
    var userID: String?
    
    @IBAction func unwindToMessageTableSegue(segue: UIStoryboardSegue){
        messagesTableView.reloadData()
    }
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
        //Grab logged in user from NSUserDefaults
        getLoggedInUser()
        getMessages()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TableView Delegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //change this to .count
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! MessagesTableViewCell
        
        //            as! MessagesTableViewCell
        
        //        let endPoint:String = "http://localhost:3000/messages"
        //
        //        let parameters = [
        //            "first_name": firstName,
        //            "last_name": lastName,
        //            "email": email,
        //            "facebook_id": id,
        //            "picture_url": pictureUrl,
        //            ]
        //
        //        Alamofire.request(.GET, endPoint, parameters: parameters, encoding: .JSON)
        //            .responseString { response in
        //                // print response as string for debugging, testing, etc.
        //                print(response.result.value)
        //                print(response.result.error)
        //        }
        
        //        cell.imageView.image =
        cell.senderNameLabel!.text = "Jessica Wilson"
        cell.dateLabel!.text =  "Yesterday"
        cell.unreadNumberLabel!.text =  "5 Unread Messages"
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("ChatSegue", sender: indexPath)
        
    }
    //
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return 10.0
    //    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let navController = segue.destinationViewController as! UINavigationController
        let chatVC = navController.viewControllers.first as! ChatViewController
        chatVC.senderId = userID
        chatVC.senderDisplayName = "\(firstName) \(lastName)"
        
        //SENDER ID AND DISPLAY NAME ARE CURRENT LOGGED IN USER
        
    }
    
    //Get logged in user credentials to send to JSQMessage View Controller
    func getLoggedInUser() -> String{
        let prefs = NSUserDefaults.standardUserDefaults()
        
        if let first_name = prefs.stringForKey("first_name"){
            self.firstName = first_name
            print(firstName)
        }
        if let last_name = prefs.stringForKey("last_name"){
            self.lastName = last_name
            print(lastName)
        }
        if let id = prefs.stringForKey("user_id"){
            self.userID = id
            print(userID)
        }
        
        return self.userID!
    }
    
    func getMessages() {
        
        // Setting API key once for whole session
        let manager = Alamofire.Manager.sharedInstance
        let headers = ["Accept": "text/plain"]
        let urlString = "http://localhost:3000/messages/\(userID!)"
        
        manager.request(.GET, urlString, headers: headers).responseJSON{ response in
            print("got here")
            if let value = response.result.value {
                
                let json = JSON(value)
                print(json)
                print("---------------------------------")
                
                // use SwiftyJSON
                //                for (index,subJson):(String, JSON) in json {
                //
                //                    if let latitude = subJson["latitude"].double{
                //
                //                        let latitude = subJson["latitude"].double
                //                        print(latitude)
            }
        }
        
    }
    
    
    
}



