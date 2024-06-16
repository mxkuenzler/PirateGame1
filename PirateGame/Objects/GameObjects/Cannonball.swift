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
    
    var HP: Int
    
    init(Entity: Entity, Health: Int) {
        HP = Health
        super.init(Entity: Entity, ID: ID.CANNON_BALL)
    }
    
    init(Entity: Entity, Health: Int, pos: SIMD3<Float>, relativeTo: Entity) {
        HP = Health
        
        super.init(Entity: Entity, ID: ID.CANNON_BALL)
        
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
    
    func hit(block: Block) {
        HP -= block.HP + HP
        if HP <= 0 {
            manager?.unregisterObject(object: self)
        }
        print("Ball Health: \(HP)")
    }
    
    func damageBlock(obj: Object) {
        //override
    }
    
    func damageFlag(obj: Object) {
        //override
    }
    
}
