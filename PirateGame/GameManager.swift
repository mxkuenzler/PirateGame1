//
//  GameManager.swift
//  PirateGame
//
//  Created by Student on 5/8/24.
//
import SwiftUI
import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI


class GameManager {
    
    private var rContent:RealityViewContent?
    private var lighting:EnvironmentResource?
    private var audioController:Entity?
    private var objectList:[Object]
    private var IsLevelActive = false
    private var pirateShip:PirateShip?
    private var currentLevel = 1
    
    
    init(rContent: RealityViewContent?, lighting:EnvironmentResource?, audioController:Entity?) {
        
        
        self.rContent = rContent
        self.lighting = lighting
        self.audioController = audioController
        self.objectList = Array<Object>()
    }
    
    
    func registerObject(object: Object) {
        object.initiateLighting(IBL: lighting!)
        if object.getID() != ID.EFFECT {
            object.initiatePhysicsBody()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            Task.init {
                self.rContent?.add(object.getEntity()!)
                self.objectList.append(object)
            }
        }
    }
    
    
    func unregisterObject(object: Object) {
        
        let count = 0...objectList.count-1
        
        for i in count {
            if(objectList[i] == object) {
                
                objectList[i].getEntity()?.removeFromParent()
                objectList.remove(at: i)
                return
                
            }
        }
        
        
    }
    
    func findObject(model: Entity) -> Object? {
        let count = 0...objectList.count-1
        var obj:Object?
        for i in count {
            if(objectList[i].getEntity() == model) {
                
                obj = objectList[i]
                
            }
        }
        
        return obj
    }
    
    func getObjects() -> Array<Object> {
        return objectList
    }
    
    func handleCollision(event: CollisionEvents.Began) {
        
        //HANDLE COLLISION
        
        let obj:Object? = findObject(model:event.entityA)
        
        if obj?.getID() == ID.CANNON_BALL {
            obj?.handleCollision(event:event)
        }
        if obj?.getID() == ID.SIMPLE_BLOCK {
            obj?.handleCollision(event: event)
        }
        
    }
 
    
    func setPirateShip(obj:PirateShip?) {
        pirateShip = obj
    }
    
    func isLevelActive() -> Bool {
        return IsLevelActive
    }
    
    func getCurrentLevel() -> Int {
        return currentLevel
    }
    
    func startNextLevel(level:Level) async {
        IsLevelActive = true
        let levelDuration = level.getDuration()
        
        if level.isSpecialLevel {
            await handleSpecialLevel(level:level)
        }
        else {
            await pirateShip?.shootCannonBalls(amount: level.getBallAmount(), time: level.getDuration())
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(levelDuration) + Double(5)) {
            self.IsLevelActive = false
        }
        
        currentLevel += 1
    }
    
    func endLevel(body: some View) {
        
        
        
        
    }
    
    func handleSpecialLevel(level: Level) async {
        
        let ballArr = level.getBallArray()
        let delayArr = level.getBallDelayArray()
        var totalTime:Float = 0.0
        
        for i in 0...delayArr!.count-1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(totalTime + delayArr![i])) {
                Task.init {
                    await self.pirateShip?.shootCannonBall(time: self.pirateShip!.getRandomTime(), type: ballArr![i])
                }
            }
            totalTime += delayArr![i]
        }
    
    }
    
    
        
        
        
    
    
}
