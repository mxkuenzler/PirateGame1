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
        HP -= block.HP
        if HP <= 0 {
            manager?.unregisterObject(object: self)
        }
    }
    
    func damageBlock(obj: Object) {
        //override
    }
    
    func damageFlag(obj: Object) {
        //override
    }
    
}
class BasicCannonball: Cannonball {
    var hp = 1
    init() async {
        
        let CannonballModel = try? await Entity(named: "Cannonball", in: realityKitContentBundle)
        
        super.init(Entity: CannonballModel!, Health: hp)
        
    }
    
    init(pos: SIMD3<Float>, relativeTo: Entity) async {
        
        let CannonballModel = try? await Entity(named: "Cannonball", in: realityKitContentBundle)
        
        super.init(Entity: CannonballModel!, Health: hp, pos: pos, relativeTo: relativeTo)
    }
    
    override func damageBlock(obj: Object) {
        let block:Block = obj as! Block
        block.hit(obj: self)
        manager?.unregisterObject(object: self)
    }
    
    override func damageFlag(obj: Object) {
        let flag:Flag = obj as! Flag
        flag.hit(obj: self)
        manager?.unregisterObject(object: self)
    }
}

class HeavyCannonball: Cannonball {
    var hp = 3
    init() async {
        
        let CannonballModel = try? await Entity(named: "Cannonball", in: realityKitContentBundle)
        
        super.init(Entity: CannonballModel!, Health: hp)
        
    }
    
    init(pos: SIMD3<Float>, relativeTo: Entity) async {
        
        let CannonballModel = try? await Entity(named: "Cannonball", in: realityKitContentBundle)
        
        super.init(Entity: CannonballModel!, Health: hp, pos: pos, relativeTo: relativeTo)
    }
    
    override func damageBlock(obj: Object) {
        let block:Block = obj as! Block
        block.hit(obj: self)
        hit(block: block)
    }
    
    override func damageFlag(obj: Object) {
        let flag:Flag = obj as! Flag
        flag.hit(obj: self)
        manager?.unregisterObject(object: self)
    }
}
