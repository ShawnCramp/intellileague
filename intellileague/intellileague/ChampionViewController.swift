//
//  ChampionViewController.swift
//  intellileague
//
//  Created by Don Miguel on 2016-03-31.
//  Copyright © 2016 MIT iPhone. All rights reserved.
//

import UIKit

class ChampionViewController: UIViewController {

    var itemData = NSMutableDictionary()
    var itemImg = NSData()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var champNameLabel: UILabel!
    @IBOutlet weak var subNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        champNameLabel.text = itemData.valueForKey("key") as? String
        subNameLabel.text = itemData.valueForKey("title") as? String

        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
