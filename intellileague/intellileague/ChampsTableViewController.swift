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
    var champImages : [NSURL] = []
    var champData = [NSData?]()
    
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
            print(i)
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
        let imageQ = dispatch_queue_create("Image Q", DISPATCH_QUEUE_CONCURRENT);
        
        for (i, image) in champImages.enumerate() {
            dispatch_async(imageQ, {
                print("In Dispatch")
                print(image)
                
                self.champData[i] = NSData(contentsOfURL: image)!
                dispatch_async(dispatch_get_main_queue(), {
                    print(i)
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    /*

        REST Library
    
    */
    
    func updateIP() {
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "https://na.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=image&api_key=2472734e-3298-44d5-b026-b21e290f7959"
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
                    
                    // Parse the JSON to get the IP
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    let origin = jsonDictionary["data"] as! NSDictionary
                    let sortedOrigin = (origin.allKeys as! [String]).sort(<)
                    print("JSON Champ List Size \(origin.count)")
                    print(sortedOrigin)
                    
                    // Update the label
                    for i in sortedOrigin {
                        print(i)
                        
                        let champData = origin[i] as! NSDictionary
                        let imageData = champData["image"] as! NSDictionary
                        let imageName = imageData["full"] as! String
                        
                        self.champImages.append(NSURL(string: "ddragon.leagueoflegends.com/cdn/4.18.1/img/champion/\(imageName)")!)
                        self.champNames.append(i)
                        self.champData.append(nil)
                        
                    }
                    
                    self.asyncGetImages()
                    print("Champ Image Count: \(self.champImages.count)")
                    print("Champ Data Count: \(self.champData.count)")
                    // self.tableView.reloadData()
                    
                    //self.performSelectorOnMainThread("insertList:", withObject: origin, waitUntilDone: false)
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
    }
    
    func insertList(text: String) {
        champNames.append(text)
    }

}
