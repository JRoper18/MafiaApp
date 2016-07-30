//
//  GameFinderManager.swift
//  Mafia
//
//  Created by Jack Roper on 7/29/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import Foundation
import MultipeerConnectivity;

//Note to self: Advertiser advertises that i can join, not for others to join it.
//This class advertises that it is looking for a game.
class GameConnectionAdvertiser: NSObject, MCNearbyServiceAdvertiserDelegate {
    //I think this is a description of our advertiser, not sure
    let gameServiceType = "mafia-host"
    
    //devicePeerID is what our device is shown as to other devices.
    let devicePeerID = MCPeerID(displayName: "search");
    
    //Holds the possible games you can join
    var nearbyHosts : [MCPeerID] = [];
    
    let serviceAdvertiser : MCNearbyServiceAdvertiser;
    override init(){
        //This sends out a signal to nearby devices.
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: devicePeerID, discoveryInfo: nil, serviceType: gameServiceType)
        
        super.init();
        
        print("Service advertiser created");
        
        //Starts advertising to other devices
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer();
        
    }
    deinit{
        //Stops advertising once this object is deleted
        self.serviceAdvertiser.stopAdvertisingPeer();
        
    }
    //Delegate required function called when we get an invitation
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void){
        print("Got invitation to join game from " + peerID.displayName);
        nearbyHosts.append(peerID)
    }
    
    
}
