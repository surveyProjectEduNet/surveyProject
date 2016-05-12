//
//  ViewController.swift
//  Survey
//
//  Created by mac on 5/7/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLoginWithFacebook(sender: FBSDKLoginButton) {
        
        let facebookLogin = FBSDKLoginManager()
        flat = true
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult: FBSDKLoginManagerLoginResult!,facebookError: NSError!) in
            if facebookError != nil {
                print("Facebook login failed. Error\(facebookError)")
            }else if facebookResult.isCancelled {
                print("Facebook login was cancelled")
            }else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successfully logged in with facebook. \(accessToken)")
                
                FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large)"]).startWithCompletionHandler { (connection, facebookResult, error) -> Void in
                    let strFirstName: String = (facebookResult.objectForKey("first_name") as? String)!
                    let strLastName: String = (facebookResult.objectForKey("last_name") as? String)!
                    let strPictureURL: String = (facebookResult.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                    print("First name: \(strFirstName) , Last name: \(strLastName), Picture: \(strPictureURL)")
                }
                NSUserDefaults.standardUserDefaults().setValue(SEGUE_LOGGED_IN, forKey: KEY_UID)
                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                
            }
            
        }
    }

    @IBAction func onLoginWithTwitter(sender: AnyObject) {
        flat = false
        TwitterClient.sharedInstance.login({ () -> () in
            
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
//            print("I've logged in!")
            
        }) { (error: NSError) -> () in
            print("Error \(error.localizedDescription)")
        }
    }

}

