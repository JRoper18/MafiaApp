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
    
    
    override func viewDidLoad() {
        if thisPlayer.roleToString() != "Pirate" || thisPlayer.roleToString() != "Hunter"{
            pickerView.hidden = true
        }
        
        deviceSession.delegate = self;
        playerRevealLabel.text = ""
        playerRevealLabel.hidden = true
        super.viewDidLoad();
        
        getTargetPlayers();
        
        pickerView.delegate = self;
        pickerView.dataSource = self;
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(NighttimeViewController.secondTime), userInfo: nil, repeats: false)

    }
    
    func secondTime(){
        time += 1;
        let timeLeft = 15-time;
        timerLabel.text = String(timeLeft)
        if timeLeft == 2 && thisPlayer.roleToString() == "Hunter" && hunterHasChecked == false{
            playerRevealLabel.hidden = false
            var selectedPlayerRole : String = ""
            for player in players{
                if player.name == selectedPlayer{
                    selectedPlayerRole = player.roleToString()
                    break
                }
            }
            playerRevealLabel.text = "Selected Player: \(selectedPlayerRole)"
            hunterHasChecked = true
        }
        if timeLeft <= 0 {
            let dataToSend = selectedPlayer.dataUsingEncoding(NSUTF8StringEncoding)
            try! deviceSession.sendData(dataToSend!, toPeers: deviceSession.connectedPeers, withMode: .Unreliable)
            if thisPlayer.roleToString() == "Pirate" {
                for player in players{
                    if player.name == selectedPlayer{
                        let playerID = MCPeerID(displayName: player.name)
                        try! deviceSession.sendData(dataToSend!, toPeers: [playerID], withMode: .Unreliable)
                    }
                }
            }
        }
    }
    
    func getTargetPlayers(){
        if thisPlayer.role == .Pirate {
            for player in players{
                if player.role != .Pirate{
                    targetPlayers.append(player)
                }
            }
        }
        else if thisPlayer.role == .Healer || thisPlayer.role == .Hunter{
            targetPlayers = players
        }
        else{ //Townsman
            targetPlayers = [];
        }
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("PlayerDied", sender: self)
            deviceSession.disconnect()
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
        selectedPlayer = targetPlayers[row].name;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return targetPlayers[row].name
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1;
    }
    
}
