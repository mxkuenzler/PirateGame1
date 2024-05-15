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
        
        super.init(Entity: CannonballModel!, ID: ID.CANNON_BALL)
        
        setPosition(pos: pos, relativeTo: relativeTo)
        
        await manager?.registerObject(object: self)
        
        setDynamic()
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
        
    }
    
    func setDynamic() {
        getEntity()?.components[PhysicsBodyComponent.self]?.mode = .dynamic
    }
    
    func shootBall(b:SIMD3<Float>, c:Float) {

            //a.components[PhysicsBodyComponent.self]?.isAffectedByGravity = true
            
            let distance:SIMD3<Float> = b - getEntity()!.position

            let vX = distance.x/c
            let vY = distance.y/c
            let vZ = distance.z/c


            //a.components[PhysicsBodyComponent.self]?.mode = .dynamic

            getEntity()?.components[PhysicsMotionComponent.self]?.linearVelocity = SIMD3<Float>(x:vX, y:vY + 4.9*c, z:vZ)
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
