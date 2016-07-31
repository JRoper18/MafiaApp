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
class GameConnectionBrowser: NSObject, MCNearbyServiceBrowserDelegate, MCSessionDelegate{
    
    //Another device id
    let devicePeerID = MCPeerID(displayName: "person");
    
    //The browser looking for people wanting to join
    var userBrowser : MCNearbyServiceBrowser;
    
    //Variable name is self-explanitory
    var nearbyPeople : [MCPeerID] = []
    
    
    //A session that the other users connect to (a session is like a stable connection, I think);
    var session : MCSession;
    
    override init(){
        self.userBrowser = MCNearbyServiceBrowser(peer: devicePeerID, serviceType: "mafia-host")
        
        //I tried putting this outside the init function, but I can't access the devicePeerID var then.
        self.session = MCSession(peer: devicePeerID);
        
        super.init()
        
        session.delegate = self;
        
        print("Service browser created");
        
        self.userBrowser.delegate = self
        self.userBrowser.startBrowsingForPeers()
    }
    deinit{
        self.userBrowser.stopBrowsingForPeers();
        
    }
    //We found someone! Add them to the list of people wanting a game, and invite them so they know we found them.
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?){
        nearbyPeople.append(peerID);
        print("Found searching player nearby: " + peerID.displayName);
        
        //peerID is what we are, it invites people to out session, does nothing, times out after 10 seconds.
        browser.invitePeer(peerID, toSession: self.session, withContext: nil, timeout: 10)
        
    }
    
    // A nearby user has stopped advertising.
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID){
        //Removes the player from the nearbyPeople array when they leave
        nearbyPeople.removeAtIndex(nearbyPeople.indexOf(peerID)!)
        print("Nearby player has disconnected");
    }
    
    // Remote peer changed state.
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState){
        
    }
    
    // Received data from remote peer.
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID){
        
    }
    
    // Received a byte stream from remote peer.
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID){
        
    }
    
    // Start receiving a resource from remote peer.
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress){
        
    }
    
    // Finished receiving a resource from remote peer and saved the content
    // in a temporary location - the app is responsible for moving the file
    // to a permanent location within its sandbox.
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?){
        
    }
}
