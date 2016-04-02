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
    var itemData = [NSData?]()
    var itemDict = NSMutableDictionary()
    var filtered : [String] = []
    var filteredImg = [NSData?]()
    var filteredDict = [String: NSData]()
    var filteredNameIdDict = [String : String]()
    
    //let resultsController = SearchResultsTableViewController()
    let searchController = UISearchController(searchResultsController: nil)
    
    private func makeNameImgDict() {
        let c = zip(itemNames, itemData)
        for (name, img) in c {
            self.filteredDict[name] = img
        }
        
        let d = zip(itemNames, itemDict.allKeys as! [String])
        for (name, id) in d{
            self.filteredNameIdDict[name] = id
        }
    }
    
    @IBOutlet weak var nav: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Rest Call to Retreive Champ List
        updateIP()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Enter a search term"
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        

        
        
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
        if searchController.active && searchController.searchBar.text != "" {
            return filtered.count
        }
        return itemNames.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "itemId"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ItemTableViewCell
        
        // Configure the cell...
        var s : String?
        var img : NSData?
        if searchController.active && searchController.searchBar.text != "" {
            s = filtered[indexPath.row]
            img = filteredDict[s!]
        } else {
            s = itemNames[indexPath.row]
            img = itemData[indexPath.row]
        }
        
        
        
        
        cell.itemLabel.text = s
        
        if img != nil {
        cell.itemImg.image = UIImage(data:img!)
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
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if let indexPath = tableView.indexPathForSelectedRow {
            var s: String?
            if searchController.active && searchController.searchBar.text != "" {
                s = filtered[indexPath.row]
            } else {
                s = itemNames[indexPath.row]
            }
            
            if let _ = filteredNameIdDict[s!] {
                return true
            } else {
                return false
            }
        }
        return false

    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        print(sender)
        if segue.identifier == "toItem" {
            if let indexPath = tableView.indexPathForSelectedRow {
                var s: String?
                if searchController.active && searchController.searchBar.text != "" {
                    s = filtered[indexPath.row]
                } else {
                    s = itemNames[indexPath.row]
                }

                
            print(s)
            
            let ivc = segue.destinationViewController as! ItemsViewController
            ivc.itemData = itemDict.valueForKey(filteredNameIdDict[s!]!)! as! NSMutableDictionary
            ivc.itemImg = filteredDict[s!]!

            }
        }
        
    }

    
    /*
    
    ASYNC Get Images
    
    */
    
    func asyncGetImages(){
        var threadcount = 0
        let imageQ = dispatch_queue_create("Image Q", DISPATCH_QUEUE_CONCURRENT);
        
        for (i, id) in self.itemDict.allKeys.enumerate() {
                dispatch_async(imageQ, {
                    threadcount += 1
                    
                    self.itemData[i] = NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/6.6.1/img/item/\(id).png")!)
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
    
    func filterItemsNotInSummonersRift(k:String, v:NSMutableDictionary) {
        let data = v.valueForKey(k) as! NSMutableDictionary
        let maps : NSMutableDictionary = data.valueForKey("maps") as! NSMutableDictionary
        //print(maps)
        if maps.valueForKey("11") as! Int != 1 {
            v.removeObjectForKey(k)
        }
    }
    
    /*
    
    REST Library
    
    */
    
    func updateIP() {
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "https://global.api.pvp.net/api/lol/static-data/na/v1.2/item?itemListData=from,gold,maps,into&api_key=2472734e-3298-44d5-b026-b21e290f7959"
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
                    
                    let unFiltered = jsonDictionary["data"] as! NSMutableDictionary
                    print("before filter \(self.itemDict.count)")
                    for k in unFiltered.allKeys {
                        self.filterItemsNotInSummonersRift(k as! String, v: unFiltered)
                    }
                    self.itemDict = unFiltered
                    print("after filter \(self.itemDict.count)")
                    
                    for k in self.itemDict.allKeys {
                        let v : NSMutableDictionary = self.itemDict.valueForKey(k as! String) as! NSMutableDictionary
                        self.itemData.append(nil)
                        self.itemNames.append(v.valueForKey("name") as! String)
                    }
                    
                    self.asyncGetImages()
                    self.makeNameImgDict()
      
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
    }
    
    
    func filterContentForSearchText(searchText: String) {
        filtered = itemNames.filter({( name : String) -> Bool in
            return name.lowercaseString.containsString(searchText.lowercaseString)
        })
        tableView.reloadData()
    }
}

extension ItemsTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension ItemsTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
