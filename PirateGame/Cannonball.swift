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
    
    init(){
        
        let CannonballModel = ModelEntity(mesh: .generateSphere(radius: 0.25), materials: [SimpleMaterial(color: .black, roughness: 0.8, isMetallic: false)])
        
        super.init(Model: CannonballModel, ID: ID.CANNON_BALL)
        
        self.getModel()?.components.set(InputTargetComponent())

    }
    
    override func handleCollision(event: CollisionEvents.Began) {
        
        let obj:Object? = manager?.findObject(model:event.entityB as! ModelEntity)
        
        if(obj?.getID() == ID.SIMPLE_BLOCK) {
            damageBlock(obj:obj!)
        }
        
    }
    
    func shootBall(b:SIMD3<Float>, c:Float) {

            //a.components[PhysicsBodyComponent.self]?.isAffectedByGravity = true
            
            let distance:SIMD3<Float> = b - getModel()!.position

            let vX = distance.x/c
            let vY = distance.y/c
            let vZ = distance.z/c


            //a.components[PhysicsBodyComponent.self]?.mode = .dynamic

            getModel()?.components[PhysicsMotionComponent.self]?.linearVelocity = SIMD3<Float>(x:vX, y:4.9*c, z:vZ)
    }
    
    func damageBlock(obj: Object) {
        let block:Block = obj as! Block
        block.hit(obj: self)
        manager?.unregisterObject(object: self)
    }
    
}
