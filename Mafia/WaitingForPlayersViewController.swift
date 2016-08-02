//
//  WaitingForPlayersViewController.swift
//  Mafia
//
//  Created by Jack Roper on 7/31/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit
import MultipeerConnectivity;

var thisPlayer : Player = Player(name: deviceSession.myPeerID.displayName, role: .Townsman)

var players : [Player] = [];

class WaitingForPlayersViewController: UIViewController, MCSessionDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var displayPlayersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayPlayersTableView.delegate = self
        displayPlayersTableView.dataSource = self
        print(deviceSession.myPeerID.displayName)
        deviceSession.delegate = self
        try! deviceSession.sendData(String("PlayerJoin").dataUsingEncoding(NSUTF8StringEncoding)!, toPeers: deviceSession.connectedPeers, withMode: .Unreliable)
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        //This works by when someone is ready they send the PlayerJoin message and the other devices add them to an array of players and then respond with their name, so that the new guy knows they're ready too.
        //Aparently the dispatch async thing makes this work.
        dispatch_async(dispatch_get_main_queue()) {
            self.displayPlayersTableView.reloadData();
            let command = String(data: data, encoding: NSUTF8StringEncoding)
            if command == "PlayerJoin"{
                let replyString = "PlayerJoinReply:" + (thisPlayer.roleToString());
                try! deviceSession.sendData(replyString.dataUsingEncoding(NSUTF8StringEncoding)!, toPeers: [peerID], withMode: .Unreliable);
                players.append(Player(name: peerID.displayName, role: PlayerRole.Default));
                
            }
            else if(command!.characters.count > 15){
                if command!.substringToIndex(command!.startIndex.advancedBy(16)) == "PlayerRoleReply:"{
                    for index in 0..<players.count {
                        if players[index].name == peerID.displayName {
                            players[index].role = self.stringToRole(command!.substringFromIndex(command!.startIndex.advancedBy(16)))
                        }
                    }
                    if(players.count == session.connectedPeers.count){
                        let segueString = "StartGame" + (thisPlayer.roleToString());
                        self.performSegueWithIdentifier(segueString, sender: nil);
                    }
                }
                else if command!.substringToIndex(command!.startIndex.advancedBy(16)) == "PlayerJoinReply:"{
                    //Add the new data to player array.
                    print("From: "  + peerID.displayName + " : " + String(data: data, encoding: NSUTF8StringEncoding)!);
                    let replyPlayer = Player(name: peerID.displayName, role:self.stringToRole(command!.substringFromIndex(command!.startIndex.advancedBy(16))))
                    players.append(replyPlayer)
                    thisPlayer.role = self.findRole();
                    let replyString = String("PlayerRoleReply:" + thisPlayer.roleToString())
                    try! deviceSession.sendData(replyString.dataUsingEncoding(NSUTF8StringEncoding)!, toPeers: deviceSession.connectedPeers, withMode: .Unreliable);
                    if(players.count == session.connectedPeers.count){
                        let segueString = "StartGame" + (thisPlayer.roleToString());
                        self.performSegueWithIdentifier(segueString, sender: nil);
                    }
                }
            }
                
            else{
                print("Strange message " + command!);
            }
        }
    }
    func findRole() -> PlayerRole {
        var roles : [PlayerRole] = []
        switch(deviceSession.connectedPeers.count) {
        case 1:
            roles = [.Townsman]
        case 2:
            roles = [.Pirate, .Townsman]
        case 3:
            roles = [.Pirate, .Townsman, .Townsman]
        case 4:
            roles = [.Pirate, .Townsman, .Healer, .Townsman]
        case 5:
            roles = [.Pirate, .Townsman, .Healer, .Townsman, .Hunter]
        case 6:
            roles = [.Pirate, .Townsman, .Healer, .Townsman, .Hunter, .Townsman]
        case 7:
            roles = [.Pirate, .Townsman, .Healer, .Townsman, .Hunter, .Townsman, .Pirate]
        case 8:
            roles = [.Pirate, .Townsman, .Healer, .Townsman, .Hunter, .Townsman, .Pirate, .Townsman]
        default:
            print("Strange number of peers");
        }
        var takenRoles : [PlayerRole] = []
        for player in players{
            print(player.role);
            takenRoles.append(player.role)
        }
        for role in takenRoles{
            //If the role is taken, remove ut from roles.
            if roles.contains(role){
                roles.removeAtIndex(roles.indexOf(role)!)
            }
        }
        let roleNum = arc4random_uniform(UInt32(roles.count))
        print(roles.count)
        return roles[Int(roleNum)]
    }
    func stringToRole(roleString : String) -> PlayerRole{
        switch roleString{
        case "Townsman":
            return .Townsman
        case "Healer":
            return .Healer
        case "Pirate":
            return .Pirate
        case "Hunter":
            return .Hunter
        default:
            return .Default;
        }
    }

    //Delegate required functions
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
    }
    
    //Table view functions (displays players on text view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = players[indexPath.row].name
        
        return cell
    }
    
}
