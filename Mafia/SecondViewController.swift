//
//  SecondViewController.swift
//  Mafia
//
//  Created by Saurav Desai on 7/29/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    var playersName = ""
    var possibleRoles : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "Your name: \(playersName)"
        possibleRoles = ["Pirate", "Pirate Hunter", "Doctor"]
    }

}
