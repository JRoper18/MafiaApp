//
//  DeathScreen.swift
//  Mafia
//
//  Created by Saurav Desai on 8/3/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit

class DeathScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        deviceSession.disconnect()
    }

}
