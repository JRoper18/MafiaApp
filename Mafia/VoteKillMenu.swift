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
        
        if killed == "ABSTAIN" {
            nameLabel.text = "You live another day..."
        }
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(VoteKillMenu.segue), userInfo: nil, repeats: false)
        }
    
    func segue(){
        self.performSegueWithIdentifier("ToNighttime", sender: self)
    }

}
