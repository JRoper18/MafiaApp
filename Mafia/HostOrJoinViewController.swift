//
//  HostOrJoinViewController.swift
//  Mafia
//
//  Created by Jack Roper on 7/30/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad();

    }
    @IBAction func OnJoinButtonPressed(sender: AnyObject) {
        if(DeviceNameTextField.text == nil){
            
        }
        else{
            presentViewController(LobbyViewController(), animated: true, completion: nil)
        }
    }
    @IBOutlet weak var DeviceNameTextField: UITextField!
}
