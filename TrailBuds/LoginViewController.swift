//
//  ViewController.swift
//  TrailBuds
//
//  Created by Garik Kosai on 3/17/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, logOutProtocol {
    
//    let loginButton: FBSDKLoginButton = {
//        let button = FBSDKLoginButton()
//        button.readPermissions = ["email"]
//        return button
//    }()

    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
//        view.addSubview(loginButton)
//        
//        loginButton.center = view.center
//        loginButton.delegate = self
        
        if let token = FBSDKAccessToken.currentAccessToken() {
            print("if let token part")
//            self.loginButton.hidden = true
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }
        
    }
    
    //Prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navController = segue.destinationViewController as! UINavigationController
        let controller = navController.topViewController as! ProfileViewController
        controller.delegate = self
    }
    
    func logOut() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("This function will hit after loginButtonWillLogin function")
        
        
        performSegueWithIdentifier("loginSegue", sender: nil)
        
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {

        print("Log out completed")
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        print("When they click login button, this will hit first")
        loginButton.hidden = true
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* Credits
    Mountain graphic by <a href="http://www.unocha.org">Ocha</a> from <a href="http://www.flaticon.com/">Flaticon</a> is licensed under <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0">CC BY 3.0</a>. Made with <a href="http://logomakr.com" title="Logo Maker">Logo Maker</a>
    */
    
}