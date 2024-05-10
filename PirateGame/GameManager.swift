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
    
    init(rContent: RealityViewContent?, lighting:EnvironmentResource?) {
        
        
        self.rContent = rContent
        self.lighting = lighting
        self.objectList = Array<Object>()
        
    }
    
    
    func registerObject(object: Object) {
        rContent?.add(object.getModel()!)
        object.initiateLighting(IBL: lighting!)
        object.initiatePhysicsBody()
        objectList.append(object)
        print("Registered")
    }
    
    func unregisterObject(object: Object) {
        
        let count = 0...objectList.count-1
        
        for i in count {
            if(objectList[i] == object) {
                
                objectList[i].getModel()?.removeFromParent()
                objectList.remove(at: i)
                return
                
            }
        }
        
        
    }
    
    func findObject(model: ModelEntity) -> Object? {
        let count = 0...objectList.count-1
        var obj:Object?
        for i in count {
            if(objectList[i].getModel() == model) {
                
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
        
        let obj:Object? = findObject(model:event.entityA as! ModelEntity)
        
        if obj?.getID() == ID.CANNON_BALL {
            obj?.handleCollision(event:event)
        }
        
    }
    
    
    
    
    
    
}
