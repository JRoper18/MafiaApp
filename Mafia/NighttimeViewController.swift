//
//  NighttimeViewController.swift
//  Mafia
//
//  Created by Jack Roper on 8/2/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class NighttimeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, MCSessionDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var playerRevealLabel: UILabel!
    
    var targetPlayers : [Player] = []
    var selectedPlayer : String = "";
    var time : Int = 0
    var hunterHasChecked : Bool = false
    
    var gotHealed = false;
    var healDone = false;
    
    var sentDecision = false;
    
    var timer : NSTimer!;
    
    var mafiaRemaining : Int = 0;
    
    var waitForHeals = NSTimer()
    func setVars(){
        self.targetPlayers = []
        self.selectedPlayer = "";
        self.time = 0
        self.hunterHasChecked = false
        
        self.gotHealed = false;
        self.healDone = false;
        
        self.sentDecision = false;
        
        self.timer = NSTimer();
        
        self.mafiaRemaining = 0;
        
        self.waitForHeals = NSTimer()
    }
    override func viewWillAppear(animated: Bool) {
        if thisPlayer.roleToString() != "Pirate" && thisPlayer.roleToString() != "Hunter" && thisPlayer.roleToString() != "Healer"{
            pickerView.hidden = true
        }
        setVars();
        deviceSession.delegate = self
        playerRevealLabel.text = ""
        playerRevealLabel.hidden = true
        super.viewWillAppear(animated)
        
        getTargetPlayers()
        
        for player in players{
            if player.role == .Pirate{
                mafiaRemaining += 1;
            }
        }
        
        if thisPlayer.role != .Townsman{
            selectedPlayer = targetPlayers[0].name
        }
        pickerView.delegate = self
        pickerView.dataSource = self
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(NighttimeViewController.secondTime), userInfo: nil, repeats: true)
        
    }
    
    func secondTime(){
        time += 1
        let timeLeft = 10 - time
        timerLabel.text = String(timeLeft)
        if timeLeft == 2 && thisPlayer.roleToString() == "Hunter" && hunterHasChecked == false{
            playerRevealLabel.hidden = false
            var selectedPlayerRole : String = ""
            for player in players{
                if player.name == selectedPlayer{
                    selectedPlayerRole = player.roleToString()
                }
            }
            playerRevealLabel.text = "Selected Player: \(selectedPlayerRole)"
            hunterHasChecked = true
        }
        if timeLeft <= 0 {
            print("OUT OF TIME");
            sendDecision();
        }
    }
    func sendDecision(){
        self.sentDecision = true;
        self.timer.invalidate();
        let dataToSend = String("HEREISACTION").dataUsingEncoding(NSUTF8StringEncoding)
        for player in players{
            if thisPlayer.roleToString() == "Pirate" {
                print("Looking for player " + player.name + " with id " + selectedPlayer);
                if player.name == selectedPlayer{
                    //Just send them the stuff.
                    let playerID = MCPeerID(displayName: selectedPlayer)
                    do{
                        for peer in deviceSession.connectedPeers{
                            if peer.displayName == selectedPlayer{
                                
                                //So this works, but using playerID to send doesnt. I dont even know why.
                                print(deviceSession.connectedPeers[0].displayName);
                                try deviceSession.sendData(dataToSend!, toPeers: [peer], withMode: .Unreliable)
                                //This is an error, but SOMEHOW the prints below say that the only device IS THE ONE IM SENDING TO
                                
                                self.performSegueWithIdentifier("ToDaytime", sender: self)

                                
                            }
                        }
                        
                    } catch {
                        print(deviceSession.connectedPeers[0].displayName);
                        //The statement above prints "pad". The one below prints "no device 'pad'". ARGH
                        print(String(error));
                    }
                    do{
                        try deviceSession.sendData("DidAttack".dataUsingEncoding(NSUTF8StringEncoding)!, toPeers: deviceSession.connectedPeers, withMode: .Unreliable)

                    } catch {
                        print("Error sending signal");
                    }
                }
            }
            else if thisPlayer.roleToString() == "Healer"{
                if player.name == selectedPlayer{
                    //Just send them the stuff.
                    let playerID = MCPeerID(displayName: player.name)
                    //Tell the guy that we heal him, tlel everyone that we chose our heal target.
                    do{
                        for peer in deviceSession.connectedPeers{
                            if peer.displayName == selectedPlayer{
                                try deviceSession.sendData(dataToSend!, toPeers: [peer], withMode: .Unreliable)
                            }
                        }
                    } catch {
                        print("Healer data transfer failed");
                    }
                    do{
                        try deviceSession.sendData("DidHeal".dataUsingEncoding(NSUTF8StringEncoding)!, toPeers: deviceSession.connectedPeers, withMode: .Unreliable)
                    } catch {
                        print("Healer data transfer failed");
                    }
                    
                }
            }
        }
    }
    func getTargetPlayers(){
        var isHealer = false
        for player in players{
            if thisPlayer.role == .Pirate {
                
                if player.role != .Pirate{
                    targetPlayers.append(player)
                }
            }
            else if thisPlayer.role == .Healer || thisPlayer.role == .Hunter{
                targetPlayers = players
            }
            else{ //Townsman
                targetPlayers = [];
            }
        }
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        dispatch_async(dispatch_get_main_queue()) {
            print("Got action from " + peerID.displayName)
            if !self.sentDecision{
                self.sendDecision()
            }
            let dataString = String(data: data, encoding:  NSUTF8StringEncoding)
            print(dataString);
            if(dataString == "DidHeal"){
                self.healDone = true
            }
            else if dataString == "Disconnect"{
                print("peer disconnected: updating accordingly");
                for index in 0..<players.count{
                    if players[index].name == peerID.displayName {
                        players.removeAtIndex(index)
                    }
                }
                self.pickerView.reloadAllComponents();
                
            }
            else if dataString == "DidAttack"{
                self.mafiaRemaining -= 1;
                if self.mafiaRemaining == 0{
                    self.performSegueWithIdentifier("ToDaytime", sender: self)
                }
            }
            else{
                var peerRole: PlayerRole = .Default
                self.healDone = true;
                
                for player in players{
                    if peerID.displayName == player.name{
                        peerRole = player.role
                    }
                    //Make sure the medic is still alive or nah so we can tell whether or not to wait for their signal.
                    if player.role == .Healer{ //Healer is alive and therefore isn't done.
                        print("Found a healer!")
                        self.healDone = false;
                    }
                }
                if peerRole == .Healer{
                    self.gotHealed = true;
                    
                }
                else if peerRole == .Pirate{
                    //Wait for the medic's signal so they dont kill him before he could be healed.
                    self.waitForHeals = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(NighttimeViewController.waitForSignals), userInfo: nil, repeats: true)
                    
                }
                
            }
            
        }
        
    }
    func waitForSignals(){
        print("Waiting on healer signal...");
        if self.healDone != true{
            
        }
        else{
            //K, we got medic signal, NOW we can see if I got healed or nah and if pirate killed me.
            waitForHeals.invalidate();
            if !self.gotHealed{
                self.performSegueWithIdentifier("PlayerDied", sender: self)
            }
            else{
                print("WE GOT HEALED THX MEDIC");
                self.performSegueWithIdentifier("ToDaytime", sender: self)
            }
        }
        
    }
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        dispatch_async(dispatch_get_main_queue()) {
            print("Disconnected player");
            if state == MCSessionState.NotConnected {
                for index in 0..<players.count{
                    if players[index].name == peerID.displayName {
                        print("Removing old player");
                        players.removeAtIndex(index)
                    }
                }
            }
            self.pickerView.reloadAllComponents();
        }
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
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return targetPlayers.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPlayer = targetPlayers[row].name
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return targetPlayers[row].name
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
}
