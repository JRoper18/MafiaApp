//
//  SearchForGameViewController.swift
//  Mafia
//
//  Created by Jack Roper on 7/30/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit
import MultipeerConnectivity;

class LobbyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let manager = GameConnectionManager();
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        tableView.reloadData();
        print(manager.session.connectedPeers.count);
    }
    override func viewDidLoad(){
        super.viewDidLoad();
        tableView.reloadData();
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return manager.session.connectedPeers.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("HostCell", forIndexPath: indexPath)
        cell.textLabel?.text = manager.session.connectedPeers[indexPath.row].displayName;
        return cell;
    }
}
