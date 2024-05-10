//
//  ObjectClass.swift
//  PirateGame
//
//  Created by Student on 5/8/24.
//

import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI

class Object {
    
    private var Entity:Entity?
    private var ID:ID?
    
    init(Entity: Entity, ID: ID) {
        self.Entity = Entity
        self.ID = ID
    }
    
    func spawnObject(rContent: RealityViewContent?, lighting:EnvironmentResource? ,position:SIMD3<Float>) {
        
        initiatePhysicsBody()
        initiateLighting(IBL: lighting!)
        
    }
    
    func initiatePhysicsBody() {
        
        guard let entity = Entity else { return }
        
        
        entity.components[PhysicsBodyComponent.self] = .init(PhysicsBodyComponent(
            shapes: [ShapeResource.generateBox(size: SIMD3<Float>(x: 1, y: 1, z: 1))],
            mass: 1.0,
            material: .generate(staticFriction: 0.8, dynamicFriction: 0.8, restitution: 0.05),
            mode: .static
        ))
        
        
        /*model.components[PhysicsBodyComponent.self] = .init(PhysicsBodyComponent(
            massProperties: .default,
            material: .generate(staticFriction: 0.8, dynamicFriction: 0.8, restitution: 0.05),
            mode: .static
        ))*/
        
        entity.components[PhysicsMotionComponent.self] = .init()
        
        entity.components[PhysicsBodyComponent.self]?.mode = .static
        
        entity.components[PhysicsBodyComponent.self]?.isAffectedByGravity = true
        
        entity.generateCollisionShapes(recursive: false)
        
//        model.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.5 )]))
        
    }
    
    func initiateLighting(IBL: EnvironmentResource) {
        
        let iblComponent = ImageBasedLightComponent(source: .single(IBL), intensityExponent: 0.25)
        guard let entity = Entity else { return }
            entity.components.set(iblComponent)
            entity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: entity))
        
        
    }
    
    static func ==(lhs: Object, rhs: Object) -> Bool {
        if lhs.getEntity() == rhs.getEntity(){
            return true
        }
        return false
    }
    
    func getEntity() -> Entity? {
        return Entity
    }
    
    func getID() -> ID? {
        return ID
    }
    
    func handleCollision(event: CollisionEvents.Began) {
        //override in classes
    }
    
    func setPosition(pos:SIMD3<Float>) {
        Entity?.position = pos
    }
    
}
