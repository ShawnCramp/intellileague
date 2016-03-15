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
    let BORDERWIDTH : CGFloat = 2.0
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
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
        t.layer.borderColor = UIColor.lightTextColor().CGColor
        t.layer.cornerRadius = CORNER_RADIUS
        let placeholder = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName : UIColor.lightTextColor()])
        t.attributedPlaceholder = placeholder
    }
    
    func setUpButton(b: UIButton) {
        b.layer.borderWidth = BORDERWIDTH
        b.layer.cornerRadius = CORNER_RADIUS
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // For some reason this is giving me an error...
//        if buttonEnter === sender {
//            
//            // Save Summoner Name for use in the App
//            _ = SummonerInfo()
//            SummonerInfo.summoner.name = textSummonerName.text!
//            
//            print("test")
//            
//            
//        }
        
        
    }
    

}
