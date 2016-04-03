//
//  NewBuildViewController.swift
//  intellileague
//
//  Created by Shawn Cramp on 2016-04-02.
//  Copyright © 2016 MIT iPhone. All rights reserved.
//

import UIKit

class NewBuildViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var championPicker: UITextField!
    
    // Temp Insertion Fields to get POST working
    @IBOutlet weak var inputChamp: UITextField!
    @IBOutlet weak var inputTitle: UITextField!
    @IBOutlet weak var inputRole: UITextField!
    @IBOutlet weak var inputDesc: UITextField!
    @IBOutlet weak var inputItem01: UITextField!
    @IBOutlet weak var inputItem02: UITextField!
    @IBOutlet weak var inputItem03: UITextField!
    @IBOutlet weak var inputItem04: UITextField!
    @IBOutlet weak var inputItem05: UITextField!
    @IBOutlet weak var inputItem06: UITextField!
    
    // Pickers
    @IBOutlet weak var itemPicker01: UIPickerView!
    @IBOutlet weak var itemPicker02: UIPickerView!
    
    let sample = ["a", "b", "c"]
    let sample2 = ["d", "e", "f"]
    
    
    // Globals
    var champID: NSNumber?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Pickers
        itemPicker01 = UIPickerView()
        itemPicker02 = UIPickerView()
        itemPicker01.dataSource = self
        itemPicker02.dataSource = self
        itemPicker01.delegate = self
        itemPicker02.delegate = self
        itemPicker01.tag = 0
        itemPicker02.tag = 1

        // Do any additional setup after loading the view.
        self.title = "New Build"
        
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int  {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 0 {
            return sample[row]
        } else if pickerView.tag == 1 {
            return sample2[row]
        }
        
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sample.count;
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

    /*

        Save Build
    
    */
    @IBAction func buttonSaveBuild(sender: AnyObject) {
        
        // Get Logged in Summoner and Use their username for the build post
        _ = SummonerInfo()
        let owner = SummonerInfo.summoner.name
        
        // Get Champion ID
        updateIP(self.inputChamp.text!)
        sleep(2)
        
        // Post Build
        postDataToURL(owner)
        
    }
    
    func updateIP(name: String) {
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "https://na.api.pvp.net/api/lol/static-data/na/v1.2/champion?api_key=2472734e-3298-44d5-b026-b21e290f7959"
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
                    
                    print(origin)
                    let champ = origin[name] as! NSDictionary
                    print(champ)
                    
                    self.champID = champ["id"] as? NSNumber
                    print(self.champID!)
                    
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
    }
    
    func postDataToURL(owner: String) {
        
        print("Build Information: ")
        print("Name: \(self.inputTitle.text!)")
        print("Owner: \(owner)")
        print("Champion ID: \(self.champID!)")
        print("Role: \(self.inputRole.text!)")
        print("Description: \(self.inputDesc.text!)")
        print("Item01: \(self.inputItem01)")
        print("Item02: \(self.inputItem02)")
        print("Item03: \(self.inputItem03)")
        print("Item04: \(self.inputItem04)")
        print("Item05: \(self.inputItem05)")
        print("Item06: \(self.inputItem06)")
        
        
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://guarded-brushlands-62127.herokuapp.com/api/builds/"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: AnyObject] = ["name": self.inputTitle.text!, "owner": owner, "patch": "6.4.1", "champion": self.champID!, "role": self.inputRole.text!, "description": self.inputDesc.text!, "item01": self.inputItem01.text!, "item02": self.inputItem02.text!, "item03": self.inputItem03.text!, "item04": self.inputItem04.text!, "item05": self.inputItem05.text!, "item06": self.inputItem06.text!]
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print(postParams)
        } catch {
            print("bad things happened")
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 201 else {
                    print("Not a 201 Created Call")
                    return
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                // Print what we got from the call
                print(postString)
            
                
                //self.performSelectorOnMainThread("updatePostLabel:", withObject: postString, waitUntilDone: false)
            }
            
        }).resume()
    }

}
