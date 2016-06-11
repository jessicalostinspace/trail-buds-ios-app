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
    var receiverID: String?
    
    @IBAction func unwindToMessageTableSegue(segue: UIStoryboardSegue){
        messagesTableView.reloadData()
    }
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Grab logged in user from NSUserDefaults
        getLoggedInUser()
        getMessages()

        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TableView Delegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //change this to .count
        return messages.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! MessagesTableViewCell

        let message = messages[indexPath.row]
        var delimiter = ","
        var token = message.componentsSeparatedByString(delimiter)

        //setting user images in table view
        let url = NSURL(string: token[1])
        let data = NSData(contentsOfURL: url!)
        cell.userImage!.contentMode = .ScaleAspectFit
        cell.userImage!.image = UIImage(data: data!)
        
        cell.senderNameLabel!.text = token[0]
        cell.dateLabel!.text =  "Yesterday"
        cell.unreadNumberLabel!.text =  "5 Unread Messages"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let message = messages[indexPath.row]
        let delimiter = ","
        var token = message.componentsSeparatedByString(delimiter)
        
        //Saving receiverID to let chatViewController who user is about to chat with
        senderName = token[0]
        receiverID = token[2]
        
        performSegueWithIdentifier("ChatSegue", sender: indexPath)
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let navController = segue.destinationViewController as! UINavigationController
        let chatVC = navController.viewControllers.first as! ChatViewController
        
        //SENDER ID AND DISPLAY NAME ARE CURRENT LOGGED IN USER
        chatVC.senderId = userID
        chatVC.senderDisplayName = "\(firstName) \(lastName)"
        chatVC.receiverID = receiverID!
        //This is not the logged in person
        chatVC.senderName = senderName!
        
    }
    
    //Get logged in user credentials to send to JSQMessage View Controller
    func getLoggedInUser() -> String{
        let prefs = NSUserDefaults.standardUserDefaults()
        
        if let first_name = prefs.stringForKey("first_name"){
            self.firstName = first_name
        }
        if let last_name = prefs.stringForKey("last_name"){
            self.lastName = last_name
        }
        if let id = prefs.stringForKey("user_id"){
            self.userID = id
            print(userID)
        }
        
        return self.userID!
    }
    
    private func getMessages() {
        
        let urlString = "http://localhost:3000/messages/\(userID!)"
        
        messages = []
        Alamofire.request(.GET, urlString).responseJSON { (response) -> Void in
            
            if let value = response.result.value {
        
                let json = JSON(value)
                
                // use SwiftyJSON
                for (index,subJson):(String, JSON) in json {

                    self.messages.append(
                        subJson[0]["first_name"].stringValue + " " +
                        subJson[0]["last_name"].stringValue + "," +
                        subJson[0]["picture_url"].stringValue + "," +
                        subJson[0]["facebook_id"].stringValue)
                }
            }
            self.messagesTableView.reloadData()
        }
    }
}
