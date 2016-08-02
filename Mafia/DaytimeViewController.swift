//
//  DaytimeViewController.swift
//  Mafia
//
//  Created by Saurav Desai on 8/1/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit

//Set this to true the starting arrow here and move to remove the need to test on multiple devices with bluetooth (maybe)
let devMode = true
import MultipeerConnectivity

class DaytimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var timeElapsed : Int = 0;
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var timerLabel: UILabel!
    var timer: NSTimer!;
    override func viewDidLoad() {
        if devMode == true{
            players = [Player(name: "A pirate", role: .Pirate), Player(name: "A townsman", role: .Townsman)]
        }
        super.viewDidLoad()
        
        pickerView.dataSource = self;
        pickerView.delegate = self;
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(DaytimeViewController.timerSecond), userInfo: nil, repeats: true)
    }
    func timerSecond(){
        timeElapsed += 1;
        
        //30 seconds to decide
        let timeRemaining = 30 - timeElapsed;
        timerLabel.text! = String(timeRemaining)
        if(timeRemaining == 0){
            //Stop timer
            timer.invalidate();
            
            //Kill whoever and goto nighttime.
            tallyVotes()
            
        }
    }
    func tallyVotes(){
        let voteData = String()
        deviceSession.sendData(<#T##data: NSData##NSData#>, toPeers: <#T##[MCPeerID]#>, withMode: <#T##MCSessionSendDataMode#>)
        //This needs to return the person who died.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1;
    }
    
    @IBAction func abstainButtonPressed(sender: AnyObject) {
        pickerView.hidden = !pickerView.hidden
    }
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return players.count
    }
    func pickerView(pickerView: UIPickerView,titleForRow row: Int, forComponent component: Int) -> String?{
        return players[row].name;
    }

}

