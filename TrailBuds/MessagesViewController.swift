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
    
    @IBAction func unwindToMessageTableSegue(segue: UIStoryboardSegue){
        messagesTableView.reloadData()
    }

    @IBOutlet weak var messagesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
//        
//        
//        
//        
//        let url = NSURL(string: pictureUrl)
//        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
//            if error != nil {
//                print(error)
//                return
//            }
//            
//            let image = UIImage(data: data!)
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                cell.imageView.image = image
//            })
//            
//        }).resume()
//        
        
//        cell.imageView.image =
        cell.senderNameLabel!.text = "Jessica Wilson"
        cell.dateLabel!.text =  "Yesterday"
        cell.unreadNumberLabel!.text =  "5 Unread Messages"
   
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        performSegueWithIdentifier("ChatSegue", sender: indexPath)
        
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let navController = segue.destinationViewController as! UINavigationController
        let chatVc = navController.viewControllers.first as! ChatViewController
        chatVc.senderId = String(1)
        chatVc.senderDisplayName = "Jessica"
        
        //SENDER ID AND DISPLAY NAME ARE CURRENT LOGGED IN USER
        
    }
    


}
