//
//  CannonballTypes.swift
//  PirateGame
//
//  Created by Maxwell Kuenzler on 6/14/24.
//

import Foundation
import RealityKit
import RealityKitContent

class BasicCannonball: Cannonball {
    var hp = 1
    init() async {
        
        let CannonballModel = try? await Entity(named: "BasicCannonball", in: realityKitContentBundle)
        
        super.init(Entity: CannonballModel!, Health: hp)
        
    }
    
    init(pos: SIMD3<Float>, relativeTo: Entity) async {
        
        let CannonballModel = try? await Entity(named: "BasicCannonball", in: realityKitContentBundle)
        
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

class HeavyCannonball: Cannonball {
    var hp = 3
    init() async {
        
        let CannonballModel = try? await Entity(named: "HeavyCannonball", in: realityKitContentBundle)
        
        super.init(Entity: CannonballModel!, Health: hp)
        
    }
    
    init(pos: SIMD3<Float>, relativeTo: Entity) async {
        
        let CannonballModel = try? await Entity(named: "HeavyCannonball", in: realityKitContentBundle)
        
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
