//
//  SearchForGameViewController.swift
//  Mafia
//
//  Created by Jack Roper on 7/30/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit
import MultipeerConnectivity;

class LobbyViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {
    
    let gameServiceType = "Pirate_Mafia - Game"
    
    //devicePeerID is what our device is shown as to other devices.
    var devicePeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
    
    //Finds people who are advertising.
    var serviceBrowser : MCBrowserViewController!;
    
    //Local session
    var session: MCSession!;
    
    @IBOutlet weak var deviceNameTextField: UITextField!
    var advertiser : MCAdvertiserAssistant!;
    override func viewDidLoad(){
        super.viewDidLoad();
        
    }
    func lookForGames(){
        self.session = MCSession(peer: devicePeerID)
        self.session.delegate = self;
        self.serviceBrowser = MCBrowserViewController(serviceType: gameServiceType, session: self.session)
        self.serviceBrowser.delegate = self;
        
        
        advertiser = MCAdvertiserAssistant(serviceType: gameServiceType, discoveryInfo: nil, session: self.session);
        advertiser.start();

    }
    func session(session: MCSession, didReceiveCertificate certificate: [AnyObject]?, fromPeer peerID: MCPeerID, certificateHandler: (Bool) -> Void) {
        print(certificate);
        certificateHandler(true);
    }
    @IBAction func buttonAction(sender: AnyObject) {
        if deviceNameTextField.text != nil{
            self.devicePeerID = MCPeerID(displayName: deviceNameTextField.text!);
        }
        lookForGames();
        self.presentViewController(self.serviceBrowser, animated: true, completion: nil)
    }
    
    //Called when we finish the peer selection.
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController){
        self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("ToGame", sender: nil)
    }
    //Called when we hit the cancel button
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
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
