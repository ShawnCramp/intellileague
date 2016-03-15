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
    let BORDERWIDTH : CGFloat = 2.0

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
        t.layer.borderColor = UIColor.lightTextColor().CGColor
        t.layer.cornerRadius = CORNER_RADIUS
        let placeholder = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName : UIColor.lightTextColor()])
        t.attributedPlaceholder = placeholder
    }
    
    func setUpButton(b: UIButton) {
        b.layer.borderWidth = BORDERWIDTH
        b.layer.cornerRadius = CORNER_RADIUS
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
