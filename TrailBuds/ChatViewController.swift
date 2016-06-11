//
//  SingleMessageViewController.swift
//  TrailBuds
//
//  Created by Jessica Wilson on 4/27/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Alamofire
import SwiftyJSON

class ChatViewController: JSQMessagesViewController{
    
    // MARK: Properties
    var messages = [JSQMessage]()
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    //receiver id is fbID of senderName below
    var receiverID: String?
    //Sender here is not logged in user
    var senderName: String?
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("unwindToMessageTableSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chat with \(senderName!)"
        setupBubbles()
        
        // Add avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        getMessages()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    
    // add url image
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.whiteColor()
        } else {
            cell.textView!.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    
    func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: senderDisplayName, text: text)
        messages.append(message)
        // animates the receiving of a new message on the view
        finishReceivingMessage()
    }
    
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,
                                     senderDisplayName: String!, date: NSDate!) {
        
        //SAVING message to rails database
        //receiver_id is logged in user
        let parameters = [
            "content": text,
            "sender_id": String(senderId),
            "receiver_id": receiverID!,
            "event_id": " ",
            "sender_facebook_id": String(senderId),
            ]
        
        let urlString = "http://localhost:3000/messages"
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON)
            .responseString { response in
                // print response as string for debugging, testing, etc.
                
                print(response.result.error)
        }
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        messages = []
        getMessages()
        //Reset input to empty
        finishSendingMessage()
        
    }
    
    private func getMessages() {
        
        //ReceiverID here is the person not logged in but the person that user clicked on message table view
        let urlString = "http://localhost:3000/chat/\(senderId)/\(receiverID!)"
        
        Alamofire.request(.GET, urlString).responseJSON { (response) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    // use SwiftyJSON
                    for (index,subJson):(String, JSON) in json {
                        
                        print(subJson)
                        //sender_id here needs to be sender_fb id not sender_id
                        self.addMessage(String(subJson["sender_facebook_id"]), text: String(subJson["content"]))
                    }
                    self.finishReceivingMessage()
                }
            case .Failure(let error):
                print(error)
            }
        }

    }
    
}
