//
//  Player.swift
//  Mafia
//
//  Created by Jack Roper on 7/31/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import Foundation

enum PlayerRole{
    case Pirate;
    case Detective;
    case Townsman;
    case Medic;
}

class Player {
    var name : String;
    var role : PlayerRole;
    init(name : String, role : PlayerRole){
        self.name = name;
        self.role = role;
    }
}
