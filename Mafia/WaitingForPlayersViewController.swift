//
//  WaitingForPlayersViewController.swift
//  Mafia
//
//  Created by Jack Roper on 7/31/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit
import MultipeerConnectivity;

class WaitingForPlayersViewController: UIViewController, MCSessionDelegate {
    var players : [String] = [];
    override func viewDidLoad(){
        super.viewDidLoad();
        let playerJoinNameString = "PlayerJoin:" + deviceSession.myPeerID.displayName;
        deviceSession.delegate = self;
        try! deviceSession.sendData(String("GameStart").dataUsingEncoding(NSUTF8StringEncoding)!, toPeers: deviceSession.connectedPeers, withMode: .Unreliable);
        print(deviceSession.connectedPeers.count)
        
    }
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        //Aparently the dispatch async thing makes this work.
        print("Got data");
        dispatch_async(dispatch_get_main_queue()) {
            let command = String(data);
            if command == "PlayerJoin:"{
                self.players.append(peerID.displayName);
                //If all the players are in the ready screen
                if(self.players.count == session.connectedPeers.count){
                    self.performSegueWithIdentifier("StartGame", sender: nil);

                }
            }
            else if command == "GameStart"{
                print("EEEY");
                self.performSegueWithIdentifier("StartGame", sender: nil);
            }
            else{

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
}
