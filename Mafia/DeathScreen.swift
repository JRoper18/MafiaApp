//
//  DeathScreen.swift
//  Mafia
//
//  Created by Saurav Desai on 8/3/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class DeathScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("disconnecting");
        deviceSession.disconnect()
        print(deviceSession.connectedPeers[0].displayName)
    }

}
