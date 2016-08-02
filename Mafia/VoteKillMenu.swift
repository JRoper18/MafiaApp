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
    var votes : Int = 0;
    var killed : String = "URSELF";
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "You voted to kill " + killed;
    }
}
