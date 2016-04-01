//
//  ChampsTableViewController.swift
//  intellileague
//
//  Created by Don Miguel on 2016-03-21.
//  Copyright © 2016 MIT iPhone. All rights reserved.
//

import UIKit

class ChampsTableViewController: UITableViewController {
    
    var champNames : [String] = []
    var champData = [NSData?]()
    var champDict = NSMutableDictionary()
    
    @IBOutlet weak var nav: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Rest Call to Retreive Champ List
        updateIP()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return champNames.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cellChampion"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ChampTableViewCell
        
        // Configure the cell...
        
        cell.champName.text = champNames[indexPath.row]
        
        if let i = champData[indexPath.row] {
            cell.champImg.image = UIImage(data: i)
            // print(i)
        }
        
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        if segue.identifier == "toChampion" {
            let champViewController = segue.destinationViewController as! ChampionViewController
            
            // Get the cell that generated this segue.
            if let selectedItemCell = sender as? ChampTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedItemCell)!
                let sorted = (self.champDict.allKeys as! [String]).sort(<)
                let key = sorted[indexPath.row]
                let selectedItem = self.champDict.valueForKey(key)
                champViewController.itemData = (selectedItem as? NSMutableDictionary)!
                champViewController.itemImg = self.champData[indexPath.row]!
            }
        }
    }

    
    /*
    
    ASYNC Get Images
    
    */
    
    func asyncGetImages(){
        var threadcount = 0
        let imageQ = dispatch_queue_create("Image Q", DISPATCH_QUEUE_CONCURRENT);
        
        for (i, champ) in ((self.champDict.allKeys as! [String]).sort(<)).enumerate() {
            dispatch_async(imageQ, {
                threadcount += 1
                
                self.champData[i] = NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/6.6.1/img/champion/\(champ).png")!)
                dispatch_async(dispatch_get_main_queue(), {
                    // print(i)
                    
                    self.tableView.reloadData()
                    threadcount -= 1
                })
            })
            usleep(10000)
            //print("Threads \(threadcount)")
            
        }
    }
    
    /*
    
    REST Library
    
    */
    
    func updateIP() {
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "https://na.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=image,lore,spells,stats&api_key=2472734e-3298-44d5-b026-b21e290f7959"
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
                if let _ = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    //print(ipString)
                    
                    // Parse the JSON to get the IP
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    self.champDict = jsonDictionary["data"] as! NSMutableDictionary
                    
                    for k in (self.champDict.allKeys as! [String]).sort(<) {
                        self.champData.append(nil)
                        self.champNames.append(k)
                    }
                    
                    
                    self.asyncGetImages()
                    //print("Champ Name Count: \(self.champNames.count)")
                    //print("Champ Image Count: \(self.champImages.count)")
                    //print("Champ Data Count: \(self.champData.count)")
                    // self.tableView.reloadData()
                    
                    //self.performSelectorOnMainThread("insertList:", withObject: origin, waitUntilDone: false)
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
    }
    
}
