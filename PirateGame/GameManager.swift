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
        objectList.append(object)
    }
    
    func unregisterObject(object: Object) {
        
        var count = 0...objectList.count
        
        for i in count {
            if(/*objectList[i] == object*/ true) {              //CHANGE THIS
                
                //objectList[i].getEntity().removeFromParent()      //CHANGE THIS
                objectList.remove(at: i)
                return
                
            }
        }
        
        
    }
    
    func getObjects() -> Array<Object> {
        return objectList
    }
    
    func handleCollision(event: CollisionEvents.Began) {
        
        //HANDLE COLLISION
        
    }
    
    
    
    
    
    
}
