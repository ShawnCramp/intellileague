//
//  SignUpViewController.swift
//  intellileague
//
//  Created by Don Miguel on 2016-03-14.
//  Copyright © 2016 MIT iPhone. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    let CORNER_RADIUS : CGFloat = 7.0
    let BORDERWIDTH : CGFloat = 0.5
    
    var statusPost = false
    var dupUsername = false

    @IBOutlet weak var invalidUsernameLabel: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var summoner: UITextField!
    @IBOutlet weak var signup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpTextField(username, text: "Username")
        setUpTextField(password, text: "Password")
        setUpTextField(summoner, text: "Summoner name")
        setUpButton(signup)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTextField(t: UITextField, text: String) {
        t.layer.borderWidth = BORDERWIDTH
        t.layer.borderColor = UIColor.darkGrayColor().CGColor
        t.layer.cornerRadius = CORNER_RADIUS
        let placeholder = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName : UIColor.darkGrayColor()])
        t.attributedPlaceholder = placeholder
    }
    
    func setUpButton(b: UIButton) {
        b.layer.borderWidth = BORDERWIDTH
        b.layer.borderColor = UIColor.clearColor().CGColor
        b.layer.cornerRadius = CORNER_RADIUS
    }
    
    
    // Check if Username is already in use
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if signup === sender {
            self.statusPost = true
            postDataToURL()
            
            while self.statusPost == true {
                usleep(10000)
            }
            
            if self.dupUsername == false {
                return true
            } else {
                invalidUsernameLabel.text = "Username in use"
                return false
            }
            
        }
        
        return true
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if signup === sender {
            
            // Save Summoner Information
            _ = SummonerInfo()
            SummonerInfo.summoner.name = username.text!
            SummonerInfo.summoner.summoner = summoner.text!
            
        }
        
    }

    
    
    /*
    
    REST POST Calls

    */
    func postDataToURL() {
        
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://guarded-brushlands-62127.herokuapp.com/api/summoners/"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: AnyObject] = ["username": self.username.text!, "password": self.password.text!, "summoner": self.summoner.text!]
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print(postParams)
        } catch {
            print("bad things happened")
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 201 else {
                    print("Not a 201 Created Call")
                    self.statusPost = false
                    self.dupUsername = true
                    return
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                // Print what we got from the call
                print(postString)
                
                if postString.containsString("Summoners with this username already exists") {
                    self.dupUsername = true
                } else {
                    self.dupUsername = false
                }
                
                self.statusPost = false
                
                //self.performSelectorOnMainThread("updatePostLabel:", withObject: postString, waitUntilDone: false)
            }
            
        }).resume()
    }

}
