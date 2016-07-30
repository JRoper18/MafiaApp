//
//  SearchForGameViewController.swift
//  Mafia
//
//  Created by Jack Roper on 7/30/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit
import MultipeerConnectivity;

class SearchForGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    let advertiser = GameConnectionAdvertiser();
    @IBOutlet weak var tableView: UITableView!
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        tableView.reloadData();
    }
    override func viewDidLoad(){
        super.viewDidLoad();
        tableView.reloadData();
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return advertiser.nearbyHosts.count;
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("HostCell", forIndexPath: indexPath)
        cell.textLabel?.text = advertiser.nearbyHosts[indexPath.row].displayName;
        print(advertiser.nearbyHosts[indexPath.row].displayName);
        return cell;
    }
}
