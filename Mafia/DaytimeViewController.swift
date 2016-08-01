//
//  DaytimeViewController.swift
//  Mafia
//
//  Created by Saurav Desai on 8/1/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import UIKit

class DaytimeViewController: UIViewController {

    var numPlayers = players.count
    var numPlayersCG = CGFloat(players.count)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<players.count{
            let button = UIButton(frame: CGRect(x: CGFloat(i) * self.view.frame.width / numPlayersCG, y: 50, width: self.view.frame.width / numPlayersCG, height: 70))
            button.setTitle("\(players[i].name)", forState: .Normal)
            self.view.addSubview(button)
        }
    }

}
