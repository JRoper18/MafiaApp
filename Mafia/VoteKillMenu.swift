//
//  VoteKillMenu.swift
//  Mafia
//
//  Created by Jack Roper on 8/2/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class VoteKillMenu: UIViewController, MCSessionDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    var votes : Int = 0
    var killed : String!
    var role : String!
    var timer: NSTimer!
    override func viewWillAppear(animated: Bool) {
        self.votes = 0;
        self.timer = NSTimer();
        super.viewWillAppear(animated)
        nameLabel.text = "You voted to kill " + killed + " with " + String(votes) + " votes. They were a " + role
        
        
        if killed == "ABSTAIN" {
            nameLabel.text = "No one died!"
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(VoteKillMenu.segue), userInfo: nil, repeats: false)
        
        checkWinner()
        
    }
    
    
    func segue(){
        self.performSegueWithIdentifier("ToNighttime", sender: self)
    }
    func checkWinner(){
        var mafiaWin = true
        var townWin = true
        var allPlayers = players;
        allPlayers.append(thisPlayer)
        for player in allPlayers{
            if player.role != .Pirate{
                mafiaWin = false
            }
            else if player.role == .Pirate{
                townWin = false;
            }
        }
        if mafiaWin{
            timer.invalidate()
            print("Mafia win")
            self.performSegueWithIdentifier("MafiaWin", sender: self)
        }
        if townWin{
            timer.invalidate();
            print("Mafia win")
            self.performSegueWithIdentifier("TownWin", sender: self)
        }
    }
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        dispatch_async(dispatch_get_main_queue()) {
            print("Disconnected player");
            if state == MCSessionState.NotConnected {
                for index in 0..<players.count{
                    if players[index].name == peerID.displayName {
                        players.removeAtIndex(index)
                    }
                }
                self.checkWinner();
            }
        }
    }
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
    }
    func session(session: MCSession, didReceiveCertificate certificate: [AnyObject]?, fromPeer peerID: MCPeerID, certificateHandler: (Bool) -> Void){
        certificateHandler(true);
        
        
    }
    
    
}
