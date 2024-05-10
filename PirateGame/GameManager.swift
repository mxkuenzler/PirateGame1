//
//  GameManager.swift
//  PirateGame
//
//  Created by Student on 5/8/24.
//

import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI


class GameManager {
    
    private var rContent:RealityViewContent?
    private var lighting:EnvironmentResource?
    private var objectList:[Object]
    private var coins:Int
    
    init(rContent: RealityViewContent?, lighting:EnvironmentResource?) {
        
        
        self.rContent = rContent
        self.lighting = lighting
        self.objectList = Array<Object>()
        coins = 10000
    }
    
    
    func registerObject(object: Object) {
        rContent?.add(object.getEntity()!)
        object.initiateLighting(IBL: lighting!)
        object.initiatePhysicsBody()
        objectList.append(object)
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
    
    
    func getCoins() -> Int {
        return coins
    }
    
    func setCoins(a:Int) {
        coins = a
    }
    
    
    
}
