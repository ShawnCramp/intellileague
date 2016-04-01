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
    
    var pkData : NSNumber?
    
    var imageData : NSData?
    var championData : NSNumber?
    var championName : String?
    var championTitle : String?
    
    var patchData : String?
    var descData : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get Champion Name from ID
        getChampName(championData!)
        
        // Do any additional setup after loading the view.
        buildImage.image = UIImage(data: imageData!)
        buildChampion.text = "Champion: \(championData!)"
        buildPatch.text = "Patch: \(patchData!)"
        buildDesc.text = "Description: \n\(descData!)"
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

    func updateName(text: String) {
        self.buildChampion.text = text
    }
    
    func updateTitle(text: String) {
        self.buildChampTitle.text = text
    }

}
