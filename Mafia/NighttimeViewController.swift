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
    var selectedPlayer : String = ""
    var time : Int = 0
    var hunterHasChecked : Bool = false
    
    var healDone = false
    var gotHealed = false;
    
    override func viewDidLoad() {
        if thisPlayer.roleToString() != "Pirate" && thisPlayer.roleToString() != "Hunter" && thisPlayer.roleToString() != "Healer"{
            pickerView.hidden = true
        }
        
        deviceSession.delegate = self
        playerRevealLabel.text = ""
        playerRevealLabel.hidden = true
        super.viewDidLoad()
        
        getTargetPlayers()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(NighttimeViewController.secondTime), userInfo: nil, repeats: true)
        
    }
    
    func secondTime(){
        time += 1
        let timeLeft = 15 - time
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
            let dataToSend = "HERE IS ACTION".dataUsingEncoding(NSUTF8StringEncoding)
            for player in players{
                if thisPlayer.roleToString() == "Pirate" {
                    
                    if player.name == selectedPlayer{
                        //Just send them the stuff.
                        let playerID = MCPeerID(displayName: player.name)
                        do{
                            try deviceSession.sendData(dataToSend!, toPeers: [playerID], withMode: .Unreliable)
                        } catch {
                            print("Pirate data transfer failed");
                        }
                    }
                }
                else if thisPlayer.roleToString() == "Healer"{
                    if player.name == selectedPlayer{
                        //Just send them the stuff.
                        let playerID = MCPeerID(displayName: player.name)
                        //Tell the guy that we heal him, tlel everyone that we chose our heal target.
                        do{
                            try deviceSession.sendData(dataToSend!, toPeers: [playerID], withMode: .Unreliable)
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
            //Make sure the medic is still alive or nah so we can tell whether or not to wait for their signal.
            if player.role == .Healer{
                self.healDone = true;
            }
        }
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        dispatch_async(dispatch_get_main_queue()) {
            let dataString = String(data: data, encoding:  NSUTF8StringEncoding)
            print(dataString);
            if(dataString == "DidHeal"){
                self.healDone = true
            }
            else{
                var peerRole: PlayerRole = .Default
                for player in players{
                    if peerID.displayName == player.name{
                        peerRole = player.role
                    }
                }
                if peerRole == .Healer{
                    self.gotHealed = true;
                    
                }
                else if peerRole == .Pirate{
                    //Wait for the medic's signal so they dont kill him before he could be healed.
                    let timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(NighttimeViewController.recheckHealDone), userInfo: nil, repeats: true)
                    
                }
                
            }
            
        }
        
    }
    func recheckHealDone(){
        if self.healDone != true{
            
        }
        else{
            //K, we got medic signal, NOW we can see if I got healed or nah and if pirate killed me.
            if !self.gotHealed{
                self.performSegueWithIdentifier("PlayerDied", sender: self)
            }
        }
        
    }
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        if state == MCSessionState.NotConnected {
            for index in 0..<players.count{
                if players[index].name == peerID.displayName {
                    players.removeAtIndex(index)
                }
            }
        }
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
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
