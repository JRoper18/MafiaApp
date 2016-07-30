//
//  GameConnectionBrowser.swift
//  Mafia
//
//  Created by Jack Roper on 7/29/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit
import MultipeerConnectivity

//Host that look s for people advertising that they want a game to join.
class GameConnectionBrowser: NSObject, MCNearbyServiceBrowserDelegate {
    
    //Another device id
    let devicePeerID = MCPeerID(displayName: "person");
    
    var userBrowser : MCNearbyServiceBrowser;
    
    var nearbyPeople : [MCPeerID] = []
    override init(){
        self.userBrowser = MCNearbyServiceBrowser(peer: devicePeerID, serviceType: "mafia-host")
        super.init()
        
        print("Service browser created");
        
        self.userBrowser.delegate = self
        self.userBrowser.startBrowsingForPeers()
    }
    deinit{
        self.userBrowser.stopBrowsingForPeers();
        
    }
    //We found someone! Add them to the list of people wanting a game
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?){
        nearbyPeople.append(peerID);
        print("Found searching player nearby");
        
    }
    
    // A nearby user has stopped advertising.
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID){
        //Removes the player from the nearbyPeople array when they leave
        nearbyPeople.removeAtIndex(nearbyPeople.indexOf(peerID)!)
        print("Nearby player as disconnected");
    }
}
