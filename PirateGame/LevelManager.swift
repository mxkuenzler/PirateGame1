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

class LevelManager
{
    init() { }
    
    func getLevel(num:Int) -> Level
    {
        switch num
        {
            case 1:
                return Level(levelNum: num, duration: 30, amount: 4, reward: 100)
            case 2:
                return Level(levelNum: num, duration: 30, amount: 8, reward: 100)
            case 3:
                return Level(levelNum: num, duration: 30, amount: 12, reward: 100)
            case 4:
                return Level(levelNum: num, duration: 30, amount: 16, reward: 100)
            case 5:
                return Level(levelNum: num, duration: 30, amount: 20, reward: 100)
            case 6:
                return Level(levelNum: num, duration: 40, amount: 24, reward: 100)
            case 7:
                return Level(levelNum: num, duration: 40, amount: 28, reward: 100)
            case 8:
                return Level(levelNum: num, duration: 40, amount: 32, reward: 100)
            case 9:
                return Level(levelNum: num, duration: 40, amount: 36, reward: 100)
            case 10:
                return Level(levelNum: num, duration: 40, amount: 40, reward: 100)
            case 11:
                return Level(levelNum: num, duration: 50, amount: 44, reward: 100)
            case 12:
                return Level(levelNum: num, duration: 50, amount: 48, reward: 100)
            case 13:
                return Level(levelNum: num, duration: 50, amount: 52, reward: 100)
            case 14:
                return Level(levelNum: num, duration: 50, amount: 56, reward: 100)
            case 15:
                return Level(levelNum: num, duration: 50, amount: 60, reward: 100)
            case 16:
                return Level(levelNum: num, duration: 60, amount: 64, reward: 100)
            case 17:
                return Level(levelNum: num, duration: 60, amount: 68, reward: 100)
            case 18:
                return Level(levelNum: num, duration: 60, amount: 72, reward: 100)
            case 19:
                return Level(levelNum: num, duration: 60, amount: 76, reward: 100)
            case 20:
                return Level(levelNum: num, duration: 60, amount: 80, reward: 100)
            default:
                return Level(levelNum: num, duration: 40, amount: Int(8*sqrt(Double(num))), reward: 100)
        }
    }
}
