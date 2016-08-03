//
//  DaytimeViewController.swift
//  Mafia
//
//  Created by Saurav Desai on 8/1/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit

//Set this to true the starting arrow here and move to remove the need to test on multiple devices with bluetooth (maybe)
let devMode = false
import MultipeerConnectivity

class DaytimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, MCSessionDelegate {
    
    var timeElapsed : Int = 0
    var votes : [String] = []
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var timerLabel: UILabel!
    var hasSent = false
    var timer: NSTimer!
    var selectedVote : String = players[0].name
    var highestVote : (String, Int) = ("ABSTAIN", 0)
    override func viewDidLoad() {
        if devMode == true{
            players = [Player(name: "A pirate", role: .Pirate), Player(name: "A townsman", role: .Townsman)]
        }
        super.viewDidLoad()
        deviceSession.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(DaytimeViewController.timerSecond), userInfo: nil, repeats: true)
    }
    func timerSecond(){
        timeElapsed += 1
        
        //30 seconds to decide
        let timeRemaining = 5 - timeElapsed
        timerLabel.text! = String(timeRemaining)
        if(timeRemaining == 0){
            //Stop timer
            print("Out of time!")
            timer.invalidate()
            //Kill whoever and goto nighttime.
            tallyVotes()
            
            
        }
    }
    func tallyVotes(){
        hasSent = true

        if !devMode{
            self.timer.invalidate()
            self.votes.append(self.selectedVote)
            var voteData = selectedVote.dataUsingEncoding(NSUTF8StringEncoding)
            
            if pickerView.hidden{
                voteData = "ABSTAIN".dataUsingEncoding(NSUTF8StringEncoding)
            }
            try! deviceSession.sendData(voteData!, toPeers: deviceSession.connectedPeers, withMode: .Unreliable)

        }
        
        
    }
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        dispatch_async(dispatch_get_main_queue()) {
            
            let dataString = String(data: data, encoding: NSUTF8StringEncoding)
            if dataString == "Death"{
                print("DEAD GUY!")
                
                self.performSegueWithIdentifier("ToDeath", sender: self)

                
            }
            else{ // A vote signal
                
                print("Got vote for ", dataString)
                if !self.hasSent{
                    //We didn't reach 0 yet, but they're done, so we have to move on whether we want to or not. Get our data and send it back before its too late.
                    print("Shit! Send everyone else my vote before its too late!")
                    self.tallyVotes()
                    
                }
                self.votes.append(dataString!)
                var voteCount : [(String, Int)] = []
                print("We have " , self.votes.count , "Out of ", String(players.count + 1))
                if(self.votes.count == players.count + 1){
                    print("All votes are in! Lets gooooo")
                    //Great, all votes are in! Find the most common one.
                    for vote in self.votes{
                        print("Vote for " + vote)
                        var alreadyExists = false
                        for index in 0..<voteCount.count{
                            if vote == voteCount[index].0{
                                voteCount[index].1 += 1
                                alreadyExists = true
                                
                            }
                        }
                        //If this is the first vote for that person, add them to the voted for array.
                        if !alreadyExists{
                            voteCount.append((vote, 1))
                        }
                    }
                    //Now that we have all the guilty people, find the guy with the most votes.
                    self.highestVote = ("ABSTAIN", 0)
                    for vote in voteCount{
                        if vote.1 == self.highestVote.1{
                            //Tie means no one dies.
                            self.highestVote = ("ABSTAIN", vote.1)
                        }
                        else if vote.1 > self.highestVote.1{
                            self.highestVote = vote
                        }
                    }
                    //Send the "YOU DIED" message to dead guy.
                    let dataToSend = "Death".dataUsingEncoding(NSUTF8StringEncoding)
                    if self.highestVote.0 == "ABSTAIN"{
                        
                    }
                    else{
                        let personToSendTo = MCPeerID(displayName: self.highestVote.0)
                        if deviceSession.myPeerID.displayName == personToSendTo.displayName{
                            //O shit im dead
                            self.performSegueWithIdentifier("ToDeath", sender: self)
                        }
                        else{
                            print("Sending death message to " + personToSendTo.displayName)
                            do{
                                try deviceSession.sendData(dataToSend!, toPeers: [personToSendTo], withMode: .Unreliable)
                            } catch {
                                print("Error transfer to " + personToSendTo.displayName)
                            }
                        }
                    }
                    print("Segueing")
                    self.performSegueWithIdentifier("VoteToKill", sender: self)
                }
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "VoteToKill" {
            let dvc = segue.destinationViewController as! VoteKillMenu
            dvc.killed = self.highestVote.0
            dvc.votes = self.highestVote.1
            var foundPlayer = false
            for player in players{
                if player.name == self.highestVote.0{
                    dvc.role = player.roleToString()
                    foundPlayer = true
                    break
                }
            }
            if !foundPlayer{ //We must've abstained
                dvc.role = "No Role"
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
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    @IBAction func abstainButtonPressed(sender: AnyObject) {
        pickerView.hidden = !pickerView.hidden
        if pickerView.hidden{
            selectedVote = "ABSTAIN"
        }
    }
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return players.count
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedVote = players[row].name
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return players[row].name
    }
    
}

