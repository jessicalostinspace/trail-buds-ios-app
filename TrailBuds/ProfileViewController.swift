//
//  ProfileViewController.swift
//  TrailBuds
//
//  Created by Jessica Wilson on 3/17/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, FBSDKLoginButtonDelegate {
    
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var birthday: String = ""
    var gender: String = ""
    var facebook_id: String = ""
    var userDescription: String = ""
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    var ref: Firebase!
    var events = [FDataSnapshot]()
    
    
    //This is a test
    var delegate: logOutProtocol?
    
    
    //MARK: Attributes
    
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var profileScrollView: UIScrollView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    //Table Views
    @IBOutlet weak var upcomingHikesTableView: UITableView!
    
    @IBOutlet weak var attendedHikesTableView: UITableView!
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!

    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.delegate = self
        fetchProfile()
        
        profileScrollView.contentSize.height = 750
        
        view.addSubview(profilePicture)
        view.addSubview(nameLabel)
        view.addSubview(locationLabel)
        
        // Table view delgates and data sources
        upcomingHikesTableView.delegate = self
        upcomingHikesTableView.dataSource = self
        
        attendedHikesTableView.delegate = self
        attendedHikesTableView.dataSource = self
        
        descriptionTextField.delegate = self
        // initialize firebase ref
        ref = Firebase(url:"https://trailbuds.firebaseio.com/users")
        
        
    }
    
    //    override func viewWillAppear(animated: Bool) {
    //        super.viewWillAppear(true)
    //
    //
    //
    //    }
    //
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil) {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // Navigate to other view
        }
        
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        print("profile logout button pressed")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginVC = storyboard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = LoginVC
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func fetchProfile(){
        
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), gender, location, birthday"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil{
                print(error)
                return
            }
            
            self.profilePicture.contentMode = .ScaleAspectFit
            
            let email = result["email"] as? String
            let firstName = result["first_name"] as? String
            let lastName = result["last_name"] as? String
            //            let birthday = result["birthday"] as? String
            //            let gender = result["gender"] as? String
            let id = result["id"] as? String
            self.nameLabel.text = "\(firstName!) \(lastName!)"
            //            self.locationLabel.text = "\(location)"
            //
            
            self.facebook_id = id!
            
            var pictureUrl = ""
            
            if let picture = result["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary, url = data["url"] as? String {
                pictureUrl = url
            }
            
            // SAVING TO RAILS
            
            self.createUser(firstName!, lastName: lastName!, email: email!, id: id!, pictureUrl: pictureUrl)
            
            //=========================================================
            //SAVING TO FIREBASE
            
            // setting user_id variable
            self.prefs.setValue(id, forKey: "user_id")
            self.prefs.setValue(firstName, forKey: "user_name")
            
            let userRef = self.ref.childByAppendingPath("users")
            
            let user = [ "firstName" : firstName!, "lastName" : lastName!, "email" : email!]
            
            //            let usersRef = userRef.childByAutoId()
            
            userRef.childByAppendingPath(id).setValue(user)
            //            userRef.setValue(users)
            
            //=========================================================
            
            //Saving to Rails
            
            
            
            
            let url = NSURL(string: pictureUrl)
            NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print(error)
                    return
                }
                
                let image = UIImage(data: data!)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.profilePicture.image = image
                })
                
            }).resume()
            
        }
    }
    
    
    @IBAction func messageButtonPressed(sender: UIButton) {
        
        
    }
    
    // MARK: Table Views
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = upcomingHikesTableView.dequeueReusableCellWithIdentifier("upcomingHikesCell", forIndexPath: indexPath) as! UpcomingHikesTableViewCell
        
        return cell
    }
    
    func createUser(firstName: String, lastName: String, email: String, id: String, pictureUrl: String){
        
        let parameters = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "facebook_id": id,
            "picture_url": pictureUrl,
            ]
        
        print("yooooooooo")
        
        let endPoint:String = "http://localhost:3000/users"
        
        Alamofire.request(.POST, endPoint, parameters: parameters, encoding: .JSON)
            .responseString { response in
                // print response as string for debugging, testing, etc.
                print(response.result.value)
                print(response.result.error)
        }
    }
    
    // MARK: Text View Delegate Methods
    
    func textViewDidEndEditing(textView: UITextView){
//        Alamofire.request(.POST, "https://trailbuds.org/show/\(id)", parameters: userDescription, encoding: .JSON)
        userDescription = descriptionTextField.text!
        print(userDescription)
        
        let parameters2 = [
            "description": descriptionTextField.text!
        ]
        
        print("Id is\(facebook_id)")
        let updateLink = "http://localhost:3000/users/\(facebook_id)"
        print(updateLink)
        Alamofire.request(.PATCH, updateLink, parameters: parameters2, encoding: .JSON)
        
    }
    
    func textViewDidChange(textView: UITextView){
        
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
