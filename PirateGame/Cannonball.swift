//
//  Cannonball.swift
//  PirateGame
//
//  Created by Maxwell Kuenzler on 5/8/24.
//

import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI

class Cannonball: Object {
    
    init() async {
        
        let CannonballModel = try? await Entity(named: "Cannonball", in: realityKitContentBundle)
        
        super.init(Entity: CannonballModel!, ID: ID.CANNON_BALL)
        
    }
    
    init(pos: SIMD3<Float>, relativeTo: Entity) async {
        
        let CannonballModel = try? await Entity(named: "Cannonball", in: realityKitContentBundle)
        
        await super.init(Entity: CannonballModel!, ID: ID.CANNON_BALL)
        
        setPosition(pos: pos, relativeTo: relativeTo)
        
        
    }
    
    override func handleCollision(event: CollisionEvents.Began) {
        
        let obj:Object? = manager?.findObject(model:event.entityB)
        
        if obj?.getID() == ID.SIMPLE_BLOCK {
            damageBlock(obj: obj!)
        }
        if obj?.getID() == ID.FLAG {
            
            damageFlag(obj: obj!)
        }
        if obj?.getID() == ID.OCEAN_FLOOR {
            manager?.unregisterObject(object: self)
        }
        if obj?.getID() == ID.SHIELD {
            manager?.unregisterObject(object: self)
        }
        
    }
    
    func setDynamic() {
        getEntity()?.components[PhysicsBodyComponent.self]?.mode = .dynamic
    }
    
    func damageBlock(obj: Object) {
        let block:Block = obj as! Block
        block.hit(obj: self)
        manager?.unregisterObject(object: self)
    }
    
    func damageFlag(obj: Object) {
        print("Flag collided")
        let flag:Flag = obj as! Flag
        flag.hit(obj: self)
        manager?.unregisterObject(object: self)
    }
}
