//
//  RoleViewController.swift
//  Mafia
//
//  Created by Saurav Desai on 8/2/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit

class RoleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var timer = NSTimer()
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(RoleViewController.segue), userInfo: nil, repeats: false)
    }
    
    func segue(){
        self.performSegueWithIdentifier("RoleToDaytime", sender: self)
    }
}
