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
        do{
            try deviceSession.sendData(playerJoinNameString.dataUsingEncoding(NSUTF8StringEncoding)!, toPeers: deviceSession.connectedPeers, withMode: .Reliable);

        } catch {
            print("An error occured while sending data");
        }
    }
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        let command = String(data);
        
        if command.substringToIndex(command.startIndex.advancedBy(10)) == "PlayerJoin:"{
            players.append(String(data: data, encoding: NSUTF8StringEncoding)!);
            //If all the players are in the ready screen
            if(players.count == session.connectedPeers.count){
                let commandString = "GameStart"
                do{
                    try session.sendData(commandString.dataUsingEncoding(NSUTF8StringEncoding)!, toPeers: deviceSession.connectedPeers, withMode: .Reliable);
                } catch {
                    print("An error occured while sending data");
                }
            }
        }
        else if command == "GameStart"{
            
        }
        else{
            print(command);
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
