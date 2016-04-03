//
//  ItemsViewController.swift
//  intellileague
//
//  Created by Don Miguel on 2016-03-31.
//  Copyright © 2016 MIT iPhone. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController {

    var itemData = NSMutableDictionary()
    var itemImg = NSData()
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var plaintextLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(itemData)
        imgView.image = UIImage(data: itemImg)
        itemLabel.text = itemData.valueForKey("name") as? String
        plaintextLabel.text = itemData.valueForKey("plaintext") as? String
        let gold : NSMutableDictionary = itemData.valueForKey("gold") as! NSMutableDictionary
        goldLabel.text = "Cost: \(gold.valueForKey("total")!) gold"
        descriptionLabel.text = itemData.valueForKey("sanitizedDescription") as? String
        
        
        
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
