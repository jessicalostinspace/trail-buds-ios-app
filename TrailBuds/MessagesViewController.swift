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
    
    var messages = [JSON]()
    var senderName: String?
    var lastReceivedMessageTime: NSDate?
    var pictureUrl: String?
    var firstName: String?
    var lastName: String?
    var userID: String?
    var senderID: String?
    
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
//        
//        let messagesArray = messages[0][indexPath.row]
//        
//        print(messagesArray)
        
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
        
        var msgArray = []
        
        let urlString = "http://localhost:3000/messages/\(userID!)"
        
        Alamofire.request(.GET, urlString).responseJSON { (response) -> Void in
            print(response)
            if let value = response.result.value {
                
                let json = JSON(value)
                print("---------------------------------")
                self.messages.append(json)

            }
            
        }
        
    }
}
