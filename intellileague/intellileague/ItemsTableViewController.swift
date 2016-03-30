//
//  ChampsTableViewController.swift
//  intellileague
//
//  Created by Don Miguel on 2016-03-21.
//  Copyright © 2016 MIT iPhone. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    
    var itemNames : [String] = []
    var itemImages = [NSURL]()
    var itemData = [NSData?]()
    
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
        return itemNames.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "itemId"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ItemTableViewCell
        
        // Configure the cell...
        
        cell.itemLabel.text = itemNames[indexPath.row]
        
        if let i = itemData[indexPath.row] {
            cell.itemImg.image = UIImage(data: i)
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    /*
    
    ASYNC Get Images
    
    */
    
    func asyncGetImages(){
        var threadcount = 0
        let imageQ = dispatch_queue_create("Image Q", DISPATCH_QUEUE_CONCURRENT);
        
        for (i, image) in itemImages.enumerate() {
            dispatch_async(imageQ, {
                threadcount += 1
                print("Threads \(threadcount)")
                
                print("In Dispatch")
                print(image)
                
                self.itemData[i] = NSData(contentsOfURL: image)!
                dispatch_async(dispatch_get_main_queue(), {
                    // print(i)
                    self.tableView.reloadData()
                    threadcount -= 1
                })
            })
            usleep(10000)
            print("Threads \(threadcount)")
            
        }
    }
    
    /*
    
    REST Library
    
    */
    
    func updateIP() {
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "https://na.api.pvp.net/api/lol/static-data/na/v1.2/item?api_key=2472734e-3298-44d5-b026-b21e290f7959"
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
                    
                    let origin = jsonDictionary["data"] as! NSDictionary
                    let originKeys = origin.allKeys as! [String]
                    //print("Item List Size \(origin.count)")
                    //print(sortedOrigin)
                    
                    // Update the label
                    var allNames = [String: String]()
                    for i in originKeys {
                        let itemData = origin[i] as! NSDictionary
                        let name = itemData["name"] as! String
                        allNames[name] = i
                        
                        
                        self.itemImages.append(NSURL(string: "http://ddragon.leagueoflegends.com/cdn/6.6.1/img/item/\(i).png")!)
                        self.itemNames.append(name)
                        self.itemData.append(nil)
                        
                    }

                    print(allNames)
                    
                    self.asyncGetImages()
                    // self.tableView.reloadData()
                    
                    //self.performSelectorOnMainThread("insertList:", withObject: origin, waitUntilDone: false)
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
    }
    
}
