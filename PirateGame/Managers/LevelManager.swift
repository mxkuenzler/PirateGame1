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
                return Level(levelNum: num, duration: 3, amount: 40, reward: 25)
            case 2:
                return Level(levelNum: num, duration: 20, amount: 8, reward: 50)
            case 3:
                return Level(levelNum: num, duration: 23, amount: 10, reward: 55)
            case 4:
                return Level(levelNum: num, duration: 20, amount: 12, reward: 70)
            case 5:
                return Level(levelNum: num, duration: 3, amount: 10, reward: 30)
            case 6:
                return Level(levelNum: num, duration: 25, amount: 24, reward: 100)
            case 7:
                return Level(levelNum: num, duration: 20, amount: 25, reward: 115)
            case 8:
                return Level(levelNum: num, duration: 32, amount: 30, reward: 125)
            case 9:
                return Level(levelNum: num, duration: 40, amount: 35, reward: 100)
            case 10:
                return Level(levelNum: num, duration: 4, amount: 25, reward: 150)
            case 11:
                return Level(levelNum: num, duration: 40, amount: 44, reward: 200)
            case 12:
                return Level(levelNum: num, duration: 40, amount: 48, reward: 220)
            case 13:
                return Level(levelNum: num, duration: 45, amount: 52, reward: 250)
            case 14:
                return Level(levelNum: num, duration: 50, amount: 56, reward: 250)
            case 15:
                return Level(levelNum: num, duration: 3, amount: 60, reward: 300)
            case 16:
                return Level(levelNum: num, duration: 60, amount: 64, reward: 330)
            case 17:
                return Level(levelNum: num, duration: 60, amount: 68, reward: 360)
            case 18:
                return Level(levelNum: num, duration: 60, amount: 72, reward: 370)
            case 19:
                return Level(levelNum: num, duration: 60, amount: 76, reward: 400)
            case 20:
                return Level(levelNum: num, duration: 3, amount: 80, reward: 500)
            default:
                return Level(levelNum: num, duration: 40, amount: Int(8*sqrt(Double(num+1))), reward: Int(8*sqrt(Double(num+1))) * 5)
        }
    }
}
