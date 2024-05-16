//
//  Level.swift
//  PirateGame
//
//  Created by Student on 5/16/24.
//

import Foundation

class Level {
    
    var duration:Float
    var cannonBallAmount:Int
    var isSpecialLevel:Bool
    var cannonBallArray:Array<String>?
    var cannonBallDelayArray:Array<Float>?
    var levelNum:Int
    
    init(levelNum:Int, duration:Float, amount:Int) {
        isSpecialLevel = false
        self.levelNum = levelNum
        self.duration = duration
        self.cannonBallAmount = amount
    }
    
    init(levelNum:Int, ballArray:Array<String>, ballDelayArray:Array<Float>) {
        isSpecialLevel = true
        self.levelNum = levelNum
        self.duration = -1
        self.cannonBallAmount = -1
        cannonBallArray = ballArray
        cannonBallDelayArray = ballDelayArray
    }
    
    func getDuration() -> Float {
        if isSpecialLevel {
            var sum:Float = 0
            for i in 0...cannonBallDelayArray!.count-1 {
                sum+=cannonBallDelayArray![i]
            }
            return sum
        }
        return duration
    }

    func getBallAmount() -> Int {
        if isSpecialLevel {
            return cannonBallArray!.count
        }
        return cannonBallAmount
    }
    
    func isSpecial() -> Bool {
        if isSpecialLevel {
            return true
        }
        return false
    }
    
    func getBallArray() -> Array<String>? {
        if isSpecialLevel {
            return cannonBallArray
        }
        return nil
    }
    
    func getBallDelayArray() -> Array<Float>?{
        if isSpecialLevel {
            return cannonBallDelayArray
        }
        return nil
    }
    
}
