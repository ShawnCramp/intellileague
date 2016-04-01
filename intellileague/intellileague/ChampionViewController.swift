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
    
    @IBOutlet var statsLabel:[UILabel] = []
    @IBOutlet var abilities: [UIImageView] = []
    @IBOutlet var abilityNames: [UILabel] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()        
        
        champNameLabel.text = itemData.valueForKey("key") as? String
        subNameLabel.text = itemData.valueForKey("title") as? String
        imageView.image = UIImage(data: itemImg)
        
        let stats : NSMutableDictionary = itemData.valueForKey("stats") as! NSMutableDictionary
        let spells : NSArray = itemData.valueForKey("spells") as! NSArray
     
       print(spells[0])
        
        for (i, statLabel) in statsLabel.enumerate() {
            var text = ""
            switch i {
            case 0:
                text = "Attack damage: \(stats.valueForKey("attackdamage")!)"
            case 1:
                text = "Health: \(stats.valueForKey("hp")!)"
            case 2:
                text = "Health regen: \(stats.valueForKey("hpregen")!)"
            case 3:
                text = "Movement speed: \(stats.valueForKey("movespeed")!)"
            case 4:
                text = "Magic resistance: \(stats.valueForKey("spellblock")!)"
            case 5:
                text = "Armor: \(stats.valueForKey("armor")!)"
            default:
                text = ""
            }
            statLabel.text = text
        }
        
        for (i, ability) in abilityNames.enumerate() {
            let spell : NSMutableDictionary = spells[i] as! NSMutableDictionary
            ability.text = spell.valueForKey("name") as? String
        }
        
        for (i, ability) in abilities.enumerate() {
            let spell : NSMutableDictionary = spells[i] as! NSMutableDictionary
            let image = spell.valueForKey("image") as! NSMutableDictionary
            let url = NSURL(string: "http://ddragon.leagueoflegends.com/cdn/6.6.1/img/spell/\(image.valueForKey("full") as! String)")
            print(url)
            ability.image = UIImage(data: NSData(contentsOfURL: url!)!)
        }
        

        
        
        

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
