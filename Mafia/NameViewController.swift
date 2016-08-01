//
//  NameViewController.swift
//  Mafia
//
//  Created by Jack Roper on 7/29/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit
import MultipeerConnectivity;

class NameViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Instruction"{
            let dvc = segue.destinationViewController as! InstructionViewController
        }
        else if segue.identifier == "Second"{
            let dvc = segue.destinationViewController as! SecondViewController
            dvc.playersName = deviceSession.myPeerID.displayName
        }
    }
}