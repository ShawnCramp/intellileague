//
//  LoginViewController.swift
//  intellileague
//
//  Created by Shawn Cramp on 2016-03-05.
//  Copyright © 2016 MIT iPhone. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let CORNER_RADIUS : CGFloat = 7.0
    let BORDERWIDTH : CGFloat = 0.5
    
    var validLogin = false
    var summonerName = ""
    var statusGet = false
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var invalidLoginLabel: UILabel!
    
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var signup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpTextField(username, text: "Username")
        setUpTextField(password, text: "Password")
        setUpButton(login)
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
    
    
    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if login === sender {
            self.statusGet = true
            updateIP()
            
            // Wait while Session is getting username (basicly a ghetto promise)
            while self.statusGet == true {
                usleep(10000)
            }
            
            print("Valid Login: \(self.validLogin)")
            if self.validLogin == true {
                print("yes")
                return true
                
            } else {
                print("no")
                invalidLoginLabel.text = "Invalid Login"
                return false
            }
        }
        
        return true
        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // For some reason this is giving me an error...
        if login === sender {
            
            // Save Summoner Name for use in the App
            _ = SummonerInfo()
            SummonerInfo.summoner.name = username.text!
            SummonerInfo.summoner.summoner = summonerName
            
        }
        
    }
    
    /*
    
    REST GET Username

    */
    
    func updateIP() {
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "http://guarded-brushlands-62127.herokuapp.com/api/summoners/?username=\(self.username.text!)"
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            do {
                if let ipString = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    print(ipString)
                    
                    if ipString != "[]" {
                        // Parse the JSON to get the IP
                        let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                        
                        let origin = jsonDictionary[0] as! NSDictionary
                        let password = origin["password"] as! String
                        print("Password: \(password)")
                        
                        if password == self.password.text! {
                            print("Password Check")
                            self.validLogin = true
                            
                            self.summonerName = origin["summoner"] as! String
                            
                        }
                    }
                    
                    // change status to returned
                    self.statusGet = false
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
    }
    

}
