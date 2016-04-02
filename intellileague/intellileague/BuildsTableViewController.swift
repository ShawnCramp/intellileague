//
//  BuildsTableViewController.swift
//  intellileague
//
//  Created by Shawn Cramp on 2016-03-31.
//  Copyright © 2016 MIT iPhone. All rights reserved.
//

import UIKit

class BuildsTableViewController: UITableViewController {
    
    // 
    var buildNames = [String]()
    var buildPatches = [String]()
    var buildChamps = [NSNumber]()
    var buildDesc = [String]()
    var buildPK = [NSNumber]()
    var buildOwner = [String]()
    
    // Image Arrays
    var buildImages = [NSURL]()
    var buildData = [NSData?]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        updateIP()
        sleep(1)
        self.asyncGetImages()
        print("IP Updates")
        // self.tableView.reloadData()
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
        return buildNames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cellBuild"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BuildTableViewCell

        // Configure the cell...
        cell.buildName.text = buildNames[indexPath.row]
        cell.buildChampion.text = "Creator: \(buildOwner[indexPath.row])"
        print(buildNames[indexPath.row])
        
        if let i = buildData[indexPath.row] {
            cell.buildImage.image = UIImage(data: i)
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
        if segue.identifier == "toBuild" {
            let buildViewController = segue.destinationViewController as! BuildViewController
            
            // Get the cell that generated this segue.
            if let selectedItemCell = sender as? BuildTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedItemCell)!
                
                if let i = buildData[indexPath.row] {
                    buildViewController.imageData = i
                }
                
                print("Selected Cell Data: ")
                print("Name: \(buildNames[indexPath.row])")
                print("Champion: \(buildChamps[indexPath.row])")
                print("Patch: \(buildPatches[indexPath.row])")
                print("Desc: \(buildDesc[indexPath.row])")
                
                
                buildViewController.title = buildNames[indexPath.row]
                buildViewController.championData = buildChamps[indexPath.row]
                buildViewController.patchData = buildPatches[indexPath.row]
                buildViewController.descData = buildDesc[indexPath.row]
                buildViewController.pkData = buildPK[indexPath.row]
                buildViewController.owner = buildOwner[indexPath.row]
                
            }
            
            
        }
    }

    
    /*
    
    ASYNC Get Images
    
    */
    
    func asyncGetImages(){
        print("getting async")
        var threadcount = 0
        let imageQ = dispatch_queue_create("Image Q", DISPATCH_QUEUE_CONCURRENT);
        
        for (i, image) in buildImages.enumerate() {
            dispatch_async(imageQ, {
                threadcount += 1
                //print("Threads \(threadcount)")
                
                //print("In Dispatch")
                print(image)
                //print()
                self.buildData[i] = NSData(contentsOfURL: image)!
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

    REST GET Calls
    
    */
    func updateIP() {
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "http://guarded-brushlands-62127.herokuapp.com/api/builds/"
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
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    
                    // Convert Data Array to Dictionary
                    for i in jsonDictionary {
                        let j = i as! NSDictionary
                        let name = j["name"] as! String
                        let patch = j["patch"] as! String
                        let champion = j["champion"] as! NSNumber
                        let description = j["description"] as! String
                        let pk = j["pk"] as! NSNumber
                        let owner = j["owner"] as! String
                        print("pk: \(pk)")
                        
                        
                        // Insert Records
                        self.buildNames.append(name)
                        self.buildPatches.append(patch)
                        self.buildChamps.append(champion)
                        self.buildDesc.append(description)
                        self.buildPK.append(pk)
                        self.buildData.append(nil)
                        self.buildOwner.append(owner)
                        
                        
                        self.getChampImage(champion)
                        //self.performSelectorOnMainThread("getChampImage:", withObject: champion, waitUntilDone: false)
                        
                    }
                    
                    print(self.buildNames.count)
                    
                    
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
    }
    
    // Get Champion Image from ID
    func getChampImage(id: NSNumber) {
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "https://na.api.pvp.net/api/lol/static-data/na/v1.2/champion/\(id)?champData=image&api_key=2472734e-3298-44d5-b026-b21e290f7959"
        print(postEndpoint)
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
                    print("Getting Champion Image")
                    print(ipString)
                    
                    // Parse the JSON to get the IP
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    let origin = jsonDictionary["image"] as! NSDictionary
                    let imageName = origin["full"] as! String
                    let url = NSURL(string: "http://ddragon.leagueoflegends.com/cdn/6.6.1/img/champion/\(imageName)")!
                    print(url)
                    
                    self.buildImages.append(url)
                    
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
    }

}
