//
//  SummonerViewController.swift
//  intellileague
//
//  Created by Shawn Cramp on 2016-03-30.
//  Copyright © 2016 MIT iPhone. All rights reserved.
//

import UIKit

class SummonerViewController: UIViewController {
    
    // Summoner Information
    @IBOutlet weak var summonerLevel: UILabel!
    @IBOutlet weak var summonerName: UILabel!
    @IBOutlet weak var summonerIcon: UIImageView!
    
    // Averages Labels (Normals)
    @IBOutlet weak var normWins: UILabel!
    @IBOutlet weak var normLoss: UILabel!
    @IBOutlet weak var normKills: UILabel!
    @IBOutlet weak var normMinions: UILabel!
    @IBOutlet weak var normTurrets: UILabel!
    
    // Averages Labels (Ranked)
    @IBOutlet weak var rankWins: UILabel!
    @IBOutlet weak var rankLoss: UILabel!
    @IBOutlet weak var rankKills: UILabel!
    @IBOutlet weak var rankMinions: UILabel!
    @IBOutlet weak var rankTurrets: UILabel!
    
    // View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sanity Check
        print("Summoner Page")
        
        // Do any additional setup after loading the view.
        _ = SummonerInfo()
        updateIP()
        
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
    
    REST Library
    
    */
    
    func updateIP() {
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/\(SummonerInfo.summoner.summoner)?api_key=2472734e-3298-44d5-b026-b21e290f7959"
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
                    
                    // Get Summoner Information from Returned Object
                    let name = (jsonDictionary.allKeys as! [String])[0]
                    let origin = jsonDictionary[name] as! NSDictionary
                    
                    // Get Summoner Name and ID
                    let sumName = origin["name"] as! String
                    let sumID = origin["id"] as! NSNumber
                    print("INT ID: \(sumID)")
                    print(sumName)
                    
                    // Get Summoner Level
                    let sumLevel = origin["summonerLevel"] as! NSNumber
                    print(sumLevel)
                    
                    // Get Summoner Icon
                    let sumIcon = origin["profileIconId"] as! NSNumber
                    let sumIconUrl = NSURL(string: "http://ddragon.leagueoflegends.com/cdn/6.6.1/img/profileicon/\(sumIcon).png")
                    print(sumIconUrl)
                    
                    // Dispatch Threads to Edit Summoner Information
                    self.performSelectorOnMainThread("updateName:", withObject: sumName, waitUntilDone: false)
                    self.performSelectorOnMainThread("updateIcon:", withObject: sumIconUrl, waitUntilDone: false)
                    self.performSelectorOnMainThread("updateLevel:", withObject: sumLevel, waitUntilDone: false)
                    
                    // Get Match History
                    self.summonerStatistic(sumID)
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
    }
    
    
    // Summoner Statistics
    func summonerStatistic(id: NSNumber) {
        
        // Get Time Interval and set it back 1 week
        var timeInterval = NSDate().timeIntervalSince1970
        timeInterval = timeInterval * 1000
        let timeIntervalWeek = Int(round(timeInterval - 2.628e+9))
        print(timeIntervalWeek)
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "https://na.api.pvp.net/api/lol/na/v1.3/stats/by-summoner/\(id)/summary?season=SEASON2016&api_key=2472734e-3298-44d5-b026-b21e290f7959"
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
                    
                    // Get Summoner Information from Returned Object
                    let playerSummary = jsonDictionary["playerStatSummaries"] as! NSArray
                    print(playerSummary)
                    
                    // Get Summoner Unranked Information
                    let playerUnranked = playerSummary[10]
                    
                    // Get Summoner Ranked Information
                    let playerRanked = playerSummary[8]
                    
                    // Norm Stats
                    let normData = playerUnranked as! NSDictionary
                    print("Norms")
                    print(normData)
                    let normWins = normData["wins"] as! NSNumber
                    // Norm Agg Data
                    let normAggData = normData["aggregatedStats"] as! NSDictionary
                    let normAssists = normAggData["totalAssists"] as! NSNumber
                    let normKills = normAggData["totalChampionKills"] as! NSNumber
                    let normMinions = normAggData["totalMinionKills"] as! NSNumber
                    let normTurrets = normAggData["totalTurretsKilled"] as! NSNumber
                    
                    // Ranked Stats
                    let rankData = playerRanked as! NSDictionary
                    print("Ranked")
                    print(rankData)
                    let rankWins = rankData["wins"] as! NSNumber
                    let rankLoss = rankData["losses"] as! NSNumber
                    
                    // Norm Agg Data
                    let rankAggData = rankData["aggregatedStats"] as! NSDictionary
                    let rankKills = rankAggData["totalChampionKills"] as! NSNumber
                    let rankMinions = rankAggData["totalMinionKills"] as! NSNumber
                    let rankTurrets = rankAggData["totalTurretsKilled"] as! NSNumber
                    
                    
                    // Dispatch Threads to Edit Summoner Information
                    self.performSelectorOnMainThread("updateNormWins:", withObject: "\(normWins)", waitUntilDone: false)
                    self.performSelectorOnMainThread("updateNormAssists:", withObject: "\(normAssists)", waitUntilDone: false)
                    self.performSelectorOnMainThread("updateNormKills:", withObject: "\(normKills)", waitUntilDone: false)
                    self.performSelectorOnMainThread("updateNormMinions:", withObject: "\(normMinions)", waitUntilDone: false)
                    self.performSelectorOnMainThread("updateNormTurrets:", withObject: "\(normTurrets)", waitUntilDone: false)
                    
                    self.performSelectorOnMainThread("updateRankWins:", withObject: "\(rankWins)", waitUntilDone: false)
                    self.performSelectorOnMainThread("updateRankLoss:", withObject: "\(rankLoss)", waitUntilDone: false)
                    self.performSelectorOnMainThread("updateRankKills:", withObject: "\(rankKills)", waitUntilDone: false)
                    self.performSelectorOnMainThread("updateRankMinions:", withObject: "\(rankMinions)", waitUntilDone: false)
                    self.performSelectorOnMainThread("updateRankTurrets:", withObject: "\(rankTurrets)", waitUntilDone: false)
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
        
    }
    
    func updateName(text: String) {
        self.summonerName.text = text
    }
    
    func updateIcon(url: NSURL) {
        let data = NSData(contentsOfURL: url)!
        self.summonerIcon.image = UIImage(data: data)
    }
    
    func updateLevel(level: NSNumber) {
        self.summonerLevel.text = "Level: \(level)"
    }
    
    // Norm Labels
    func updateNormWins(text: String) {
        self.normWins.text = text
    }
    
    func updateNormAssists(text: String) {
        self.normLoss.text = text
    }
    
    func updateNormKills(text: String) {
        self.normKills.text = text
    }
    
    func updateNormMinions(text: String) {
        self.normMinions.text = text
    }
    
    func updateNormTurrets(text: String) {
        self.normTurrets.text = text
    }
    
    // Rank Labels
    func updateRankWins(text: String) {
        self.rankWins.text = text
    }
    
    func updateRankLoss(text: String) {
        self.rankLoss.text = text
    }
    
    func updateRankKills(text: String) {
        self.rankKills.text = text
    }
    
    func updateRankMinions(text: String) {
        self.rankMinions.text = text
    }
    
    func updateRankTurrets(text: String) {
        self.rankTurrets.text = text
    }
    
    
}
