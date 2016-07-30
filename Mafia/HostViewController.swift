//
//  HostViewController.swift
//  Mafia
//
//  Created by Jack Roper on 7/30/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class HostViewController: UIViewController {
    let session = MCSession(peer: MCPeerID(displayName: "Mary"))
    let hostBrowser = GameConnectionBrowser();
    override func viewDidLoad() {
        super.viewDidLoad();
        
    }

}
