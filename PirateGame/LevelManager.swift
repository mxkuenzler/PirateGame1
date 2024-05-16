//
//  LevelManager.swift
//  PirateGame
//
//  Created by Student on 5/16/24.
//

import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI

class LevelManager {
    
    
    init() {
    }
    
    func getLevel(num:Int) -> Level {
        switch num {
        case 0:
            return Level(levelNum: num, duration: 40, amount: 8)
        case 1:
            return Level(levelNum: num, duration: 40, amount: 10)
        case 2:
            return Level(levelNum: num, duration: 40, amount: 13)
        case 3:
            return Level(levelNum: num, duration: 40, amount: 15)
        default:
            return Level(levelNum: num, duration: 40, amount: Int(8*sqrt(Double(num))))
        }
    }
}
