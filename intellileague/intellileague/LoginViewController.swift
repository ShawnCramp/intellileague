//
//  LoginViewController.swift
//  intellileague
//
//  Created by Shawn Cramp on 2016-03-05.
//  Copyright © 2016 MIT iPhone. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textSummonerName: UITextField!
    @IBOutlet weak var buttonEnter: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // For some reason this is giving me an error...
        if buttonEnter === sender {
            
            // Save Summoner Name for use in the App
            _ = SummonerInfo()
            SummonerInfo.summoner.name = textSummonerName.text!
            
            print("test")
            
            
        }
        
        
    }
    

}
