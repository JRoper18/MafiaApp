//
//  Player.swift
//  Mafia
//
//  Created by Jack Roper on 7/31/16.
//  Copyright © 2016 Jack Roper. All rights reserved.
//

import Foundation

enum PlayerRole{
    case Pirate
    case Hunter
    case Townsman
    case Healer
    case Default
}

class Player {
    var name : String
    var role : PlayerRole
    init(name : String, role : PlayerRole){
        self.name = name
        self.role = role
    }
    func roleToString() -> String{
        switch self.role{
        case .Townsman:
            return "Townsman"
        case .Healer:
            return "Healer"
        case .Pirate:
            return "Pirate"
        case .Hunter:
            return "Hunter"
        default:
            return "Default"
        }
    }
    
}

