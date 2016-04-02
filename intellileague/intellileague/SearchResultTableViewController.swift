//
//  SearchResultTableViewController.swift
//  intellileague
//
//  Created by Don Miguel on 2016-04-02.
//  Copyright © 2016 MIT iPhone. All rights reserved.
//
import UIKit

class SearchResultsTableViewController: UITableViewController, UISearchResultsUpdating {

    let sectionsTableIdentifier = "itemId"

    var names: [String] = []
    var filteredImages: [NSData] = []
    var filteredNames: [String] = []
    var itemData : [NSData?] = []
    var filteredDict = [String : NSData]()
//    
    private func makeDict() {
        let c = zip(names, itemData)
        for (name,img) in c {
            self.filteredDict[name] = img
        }
        //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: sectionsTableIdentifier)
        
      makeDict()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View Data Source Methods
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return filteredNames.count
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(sectionsTableIdentifier)
            cell!.textLabel?.text = filteredNames[indexPath.row]
            if let i = filteredDict[filteredNames[indexPath.row]] {
                cell!.imageView?.image = UIImage(data: i)
            }
            
            return cell!
    }
    
    // MARK: UISearchResultsUpdating Conformance
    func updateSearchResultsForSearchController(
        searchController: UISearchController) {
            if let searchString = searchController.searchBar.text {
                filteredNames.removeAll(keepCapacity: true)
                
                if !searchString.isEmpty {
                    let isAMatch: String -> Bool = { name in
                        // Filter out long or short names depending on which
                        // scope button is selected.
                        
                        print(searchString)
                        let range = name.rangeOfString(searchString,
                            options: NSStringCompareOptions.CaseInsensitiveSearch)
                        print(range)
                        return range != nil
                    }
                    
                    
                        let matches = names.filter(isAMatch)
                        filteredNames += matches
                        print(filteredNames)
                    
                }
                
                tableView.reloadData()
            }
    }
}

