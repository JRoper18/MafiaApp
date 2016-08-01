//
//  WaitingForPlayersViewController.swift
//  Mafia
//
//  Created by Jack Roper on 7/31/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit
import MultipeerConnectivity;

class WaitingForPlayersViewController: UIViewController, MCSessionDelegate,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var displayPlayersTableView: UITableView!{
        didSet {
            displayPlayersTableView.dataSource = self
        }
    }
    
    var players : [String] = []
    
    override func viewDidLoad(){
        super.viewDidLoad()
        displayPlayersTableView.delegate = self
        displayPlayersTableView.dataSource = self
        
        deviceSession.delegate = self
        try! deviceSession.sendData(String("PlayerJoin").dataUsingEncoding(NSUTF8StringEncoding)!, toPeers: deviceSession.connectedPeers, withMode: .Unreliable)
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        //This works by when someone is ready they send the PlayerJoin message and the other devices add them to an array of players and then respond with their name, so that the new guy knows they're ready too.
        
        //Aparently the dispatch async thing makes this work.
        dispatch_async(dispatch_get_main_queue()) {
            let command = String(data)
            if command == "PlayerJoin"{
                try! deviceSession.sendData(String("PlayerJoinReply").dataUsingEncoding(NSUTF8StringEncoding)!, toPeers: [peerID], withMode: .Unreliable);
                self.players.append(peerID.displayName);
                //If all the players are in the ready screen
                if(self.players.count == session.connectedPeers.count){
                    self.performSegueWithIdentifier("StartGame", sender: nil);
                }
            }
            else if command == "PlayerJoinReply"{
                //Add the new data to player array.
                self.players.append(peerID.displayName);
                if(self.players.count == session.connectedPeers.count){
                    self.performSegueWithIdentifier("StartGame", sender: nil)
                }
            }
            else{
                print("Strange message")
            }
        }
    }
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = players[indexPath.row]
        
        return cell
    }

}
