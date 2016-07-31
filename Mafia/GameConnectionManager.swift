//
//  GameFinderManager.swift
//  Mafia
//
//  Created by Jack Roper on 7/29/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit
import MultipeerConnectivity;

//Note to self: Advertiser advertises that I can join, not for others to join it.
//This class advertises that it is looking for a game.
class GameConnectionManager: NSObject, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate, MCNearbyServiceBrowserDelegate {
    //I think this is a description of our device, not sure
    let gameServiceType = "mafia-game"
    
    //devicePeerID is what our device is shown as to other devices.
    let devicePeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
    
    //Tells others that I am looking to join someone
    let serviceAdvertiser : MCNearbyServiceAdvertiser;
    
    //Finds people who are advertising.
    let serviceBrowser : MCNearbyServiceBrowser;
    
    //Local session
    let session: MCSession;
    
    override init(){
        //This sends out a signal to nearby devices.
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: devicePeerID, discoveryInfo: nil, serviceType: gameServiceType)
        //Looks for that same signal
        self.serviceBrowser = MCNearbyServiceBrowser(peer: devicePeerID, serviceType: gameServiceType)
        
        session = MCSession(peer: devicePeerID)
        
        super.init();
        
        //Starts advertising to other devices
        print("Service advertiser created");
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer();
        
        //Also look for other devices that are advertising.
        print("Service browser created");
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
        
        session.delegate = self;
        
        print("Session PeerID:" + String(self.session.myPeerID.displayName))
    }
    //Delegate required function called when we get an invitation
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void){
        //Because we dont want a connection problem, we want to connect everyone to the same session.
        //Just connect people to the oldest one.
        
        print("Got invitation to join session from " + peerID.displayName);
        invitationHandler(true, self.session)
        advertiser.stopAdvertisingPeer()

        
        
    }
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 10)
        print("Found someone looking for a session to join: " + peerID.displayName);
        
    }
    //Error function
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        print(error.localizedDescription)
    }
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        //Do something when we lost a connection to someone.
    }
    
    // Remote peer changed state.
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState){
        print("WE HAVE A PEER THATS CHANGING");
        var str = "";
        switch(state){
        case .NotConnected: str = "Not Connected";
        case .Connecting: str = "ConnectING";
        case .Connected: str="Connected";
        }
        print("Count: " + String(session.connectedPeers.count) + " State: " + str);
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
