//
//  ProfileViewController.swift
//  TrailBuds
//
//  Created by Jessica Wilson on 3/17/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var ref = Firebase(url:"https://trailbuds.firebaseio.com/")

    //This is a test
    var delegate: logOutProtocol?
    
    //instantiate Realm
    let realm = try! Realm()
    
    // Get Realm objects
    let users = try! Realm().objects(User)
    
    
    //MARK: Attributes
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.delegate = self
        
        fetchProfile()
        
//        view.addSubview(loginButton)
        view.addSubview(profilePicture)
        view.addSubview(nameLabel)
        view.addSubview(locationLabel)
        
//        self.navigationItem.loginButton
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(true)
//        
//
//        
//    }
//


//    let loginButton: FBSDKLoginButton = {
//        let button = FBSDKLoginButton()
//        button.readPermissions = ["email"]
//        return button
//    }()
    
    
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
        
//        delegate?.logOut()
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
            let location = result["location"] as? String
            let birthday = result["birthday"] as? String
            let gender = result["gender"] as? String
            let id = result["id"] as? String
            self.nameLabel.text = "\(firstName!) \(lastName!)"
//            self.locationLabel.text = "\(location)"
//            
            var pictureUrl = ""
            
            if let picture = result["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary, url = data["url"] as? String {
                pictureUrl = url
            }
            
            
            //=========================================================
            //SAVING TO FIREBASE
            
            let userRef = self.ref.childByAppendingPath("users")
            
            let user = [ "firstName" : firstName!, "lastName" : lastName!, "email" : email!]

//            let usersRef = userRef.childByAutoId()
            
            userRef.childByAppendingPath(id).setValue(user)
//            userRef.setValue(users)
          
            
            
            //=========================================================
            //SAVING TO REALM
            
            let user1 = User()
            
            user1.firstName = firstName!
            user1.lastName = lastName!
            user1.email = email!
            user1.id = id!
            
            try! self.realm.write {
                self.realm.add(user1)
            }
            //=========================================================
            
            
            
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
