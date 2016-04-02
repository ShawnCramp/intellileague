//
//  BuildViewController.swift
//  intellileague
//
//  Created by Shawn Cramp on 2016-04-01.
//  Copyright © 2016 MIT iPhone. All rights reserved.
//

import UIKit

class BuildViewController: UIViewController {
    
    @IBOutlet weak var buildImage: UIImageView!
    @IBOutlet weak var buildChampion: UILabel!
    @IBOutlet weak var buildPatch: UILabel!
    @IBOutlet weak var buildDesc: UITextView!
    @IBOutlet weak var buildChampTitle: UILabel!
    @IBOutlet weak var buildOwner: UILabel!
    
    
    // Images
    @IBOutlet weak var item01Image: UIImageView!
    @IBOutlet weak var item02Image: UIImageView!
    @IBOutlet weak var item03Image: UIImageView!
    @IBOutlet weak var item04Image: UIImageView!
    @IBOutlet weak var item05Image: UIImageView!
    @IBOutlet weak var item06Image: UIImageView!
    
    
    var pkData : NSNumber?
    
    var imageData : NSData?
    var championData : NSNumber?
    var championName : String?
    var championTitle : String?
    var owner : String?
    
    var patchData : String?
    var descData : String?
    
    // Item IDs
    var item01 : NSNumber?
    var item02 : NSNumber?
    var item03 : NSNumber?
    var item04 : NSNumber?
    var item05 : NSNumber?
    var item06 : NSNumber?
    
    // Item Data
    var item01Data : NSData?
    var item02Data : NSData?
    var item03Data : NSData?
    var item04Data : NSData?
    var item05Data : NSData?
    var item06Data : NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get Champion Name from ID
        getChampName(championData!)
        updateItems()
        sleep(1)
        getItemData()
        sleep(1)
        
        // Do any additional setup after loading the view.
        buildImage.image = UIImage(data: imageData!)
        buildChampion.text = "Champion: \(championData!)"
        buildPatch.text = "Patch: \(patchData!)"
        buildDesc.text = "Description: \n\(descData!)"
        buildOwner.text = "Creator: \(owner!)"
        
        // Set Images
        item01Image.image = UIImage(data: item01Data!)
        item02Image.image = UIImage(data: item02Data!)
        item03Image.image = UIImage(data: item03Data!)
        item04Image.image = UIImage(data: item04Data!)
        item05Image.image = UIImage(data: item05Data!)
        item06Image.image = UIImage(data: item06Data!)
        
        print("Build Key: \(pkData!)")
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
    
    // Get Champion Image from ID
    func getChampName(id: NSNumber) {
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "https://na.api.pvp.net/api/lol/static-data/na/v1.2/champion/\(id)?api_key=2472734e-3298-44d5-b026-b21e290f7959"
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
                    print("Getting Champion Name")
                    print(ipString)
                    
                    // Parse the JSON to get the IP
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    self.championName = jsonDictionary["name"] as? String
                    self.championTitle = jsonDictionary["title"] as? String
                    
                    print(url)
                    
                    // Dispatch Threads to Edit Summoner Information
                    self.performSelectorOnMainThread("updateName:", withObject: self.championName, waitUntilDone: false)
                    self.performSelectorOnMainThread("updateTitle:", withObject: self.championTitle, waitUntilDone: false)
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
    }
    
    /*
    
    GET items from build

    */
    
    func updateItems() {
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "http://guarded-brushlands-62127.herokuapp.com/api/builds/\(pkData!)"
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
                    print("Item Information")
                    print(ipString)
                    
                    // Parse the JSON to get the IP
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    print(jsonDictionary["item01"]!)
                    self.item01 = jsonDictionary["item01"] as? NSNumber
                    self.item02 = jsonDictionary["item02"] as? NSNumber
                    self.item03 = jsonDictionary["item03"] as? NSNumber
                    self.item04 = jsonDictionary["item04"] as? NSNumber
                    self.item05 = jsonDictionary["item05"] as? NSNumber
                    self.item06 = jsonDictionary["item06"] as? NSNumber
                    
                    
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
    }
    
    func getItemData() {
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "https://global.api.pvp.net/api/lol/static-data/na/v1.2/item?itemListData=image&api_key=2472734e-3298-44d5-b026-b21e290f7959"
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
                    //print("Item Information")
                    //print(ipString)
                    
                    // Parse the JSON to get the IP
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    let origin = jsonDictionary["data"] as! NSDictionary
                    
                    // Handle Item01
                    var info = origin["\(self.item01!)"] as! NSDictionary
                    var image = info["image"] as! NSDictionary
                    var imagename = image["full"] as! String
                    var url = NSURL(string: "http://ddragon.leagueoflegends.com/cdn/6.6.1/img/item/\(imagename)")
                    self.item01Data = NSData(contentsOfURL: url!)
                    
                    // Handle Item02
                    info = origin["\(self.item02!)"] as! NSDictionary
                    image = info["image"] as! NSDictionary
                    imagename = image["full"] as! String
                    url = NSURL(string: "http://ddragon.leagueoflegends.com/cdn/6.6.1/img/item/\(imagename)")
                    self.item02Data = NSData(contentsOfURL: url!)
                    
                    // Handle Item03
                    info = origin["\(self.item03!)"] as! NSDictionary
                    image = info["image"] as! NSDictionary
                    imagename = image["full"] as! String
                    url = NSURL(string: "http://ddragon.leagueoflegends.com/cdn/6.6.1/img/item/\(imagename)")
                    self.item03Data = NSData(contentsOfURL: url!)
                    
                    // Handle Item03
                    info = origin["\(self.item04!)"] as! NSDictionary
                    image = info["image"] as! NSDictionary
                    imagename = image["full"] as! String
                    url = NSURL(string: "http://ddragon.leagueoflegends.com/cdn/6.6.1/img/item/\(imagename)")
                    self.item04Data = NSData(contentsOfURL: url!)
                    
                    // Handle Item05
                    info = origin["\(self.item05!)"] as! NSDictionary
                    image = info["image"] as! NSDictionary
                    imagename = image["full"] as! String
                    url = NSURL(string: "http://ddragon.leagueoflegends.com/cdn/6.6.1/img/item/\(imagename)")
                    self.item05Data = NSData(contentsOfURL: url!)
                    
                    // Handle Item06
                    info = origin["\(self.item06!)"] as! NSDictionary
                    image = info["image"] as! NSDictionary
                    imagename = image["full"] as! String
                    url = NSURL(string: "http://ddragon.leagueoflegends.com/cdn/6.6.1/img/item/\(imagename)")
                    self.item06Data = NSData(contentsOfURL: url!)
                    
                    
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
    }

    
    

    func updateName(text: String) {
        self.buildChampion.text = text
    }
    
    func updateTitle(text: String) {
        self.buildChampTitle.text = text
    }
    

}
