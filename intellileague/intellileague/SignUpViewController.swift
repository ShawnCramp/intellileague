//
//  SignUpViewController.swift
//  intellileague
//
//  Created by Don Miguel on 2016-03-14.
//  Copyright © 2016 MIT iPhone. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var summoner: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpTextField(username, text: "Username")
        setUpTextField(password, text: "Password")
        setUpTextField(summoner, text: "Summoner name")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTextField(t: UITextField, text: String) {
        t.layer.borderWidth = 2.0
        t.layer.borderColor = UIColor.lightTextColor().CGColor
        let placeholder = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName : UIColor.lightTextColor()])
        t.attributedPlaceholder = placeholder
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
