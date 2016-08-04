//
//  VoteKillMenu.swift
//  Mafia
//
//  Created by Jack Roper on 8/2/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit

class VoteKillMenu: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    var votes : Int = 0
    var killed : String = "URSELF"
    var role : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "You voted to kill " + killed + " with " + String(votes) + "votes. They were a " + role

        checkWinner()

        if killed == "ABSTAIN" {
            nameLabel.text = "You live another day..."
        }
        let timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(VoteKillMenu.segue), userInfo: nil, repeats: false)
        }
    
    func segue(){
        self.performSegueWithIdentifier("ToNighttime", sender: self)
    }
    func checkWinner(){
        var mafiaWin = true
        var townWin = true
        for player in players{
            if player.role != .Pirate{
                mafiaWin = false
            }
            else if player.role == .Pirate{
                townWin = false;
            }
        }
        if mafiaWin{
            self.performSegueWithIdentifier("MafiaWin", sender: self)
        }
        if townWin{
            self.performSegueWithIdentifier("TownWin", sender: self)
        }
    }

}
