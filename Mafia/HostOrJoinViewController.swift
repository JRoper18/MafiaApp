//
//  HostOrJoinViewController.swift
//  Mafia
//
//  Created by Jack Roper on 7/30/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit

class HostOrJoinViewController: UIViewController {
    @IBAction func onHostButtonTapped(sender: AnyObject) {
        browser = GameConnectionBrowser();
        
    }
    var browser : GameConnectionBrowser!;
    override func viewDidLoad() {
        super.viewDidLoad();

    }
}
