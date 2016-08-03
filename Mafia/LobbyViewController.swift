//
//  SearchForGameViewController.swift
//  Mafia
//
//  Created by Jack Roper on 7/30/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit
import MultipeerConnectivity;

//Local session
var deviceSession: MCSession!;

var advertiser : MCAdvertiserAssistant!;


class LobbyViewController: UIViewController, MCBrowserViewControllerDelegate {
    
    //The id that all people playing this game will be able to see each other.
    let gameServiceType = "mafia-game"
    
    //devicePeerID is what our device is shown as to other devices.
    var devicePeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
    
    //Finds people who are advertising.
    var serviceBrowser : MCBrowserViewController!;
    
    @IBOutlet weak var deviceNameTextField: UITextField!
    override func viewDidLoad(){
        super.viewDidLoad();
        
    }
    func lookForGames(){
        deviceSession = MCSession(peer: devicePeerID)
        self.serviceBrowser = MCBrowserViewController(serviceType: gameServiceType, session: deviceSession)
        self.serviceBrowser.delegate = self;
        //This LINE IS SUPER IMPORTANT
        //It makes the style so that segues are remembered and still work.
        self.serviceBrowser.modalPresentationStyle = .OverFullScreen;
        
        
        advertiser = MCAdvertiserAssistant(serviceType: gameServiceType, discoveryInfo: nil, session: deviceSession);
        advertiser.start();

    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true);
        advertiser.stop();
    }
    @IBAction func buttonAction(sender: AnyObject) {
        if deviceNameTextField.hasText() == true{
            self.devicePeerID = MCPeerID(displayName: deviceNameTextField.text!);
        }
        lookForGames();
        self.presentViewController(self.serviceBrowser, animated: true, completion: nil)
    }
    
    
    //Called when we finish the peer selection.
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController){
        self.performSegueWithIdentifier("ToGame", sender: self);
         
    }
    //Called when we hit the cancel button
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
