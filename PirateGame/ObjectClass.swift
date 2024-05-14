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
        self.Entity =  Entity.children.first?.children.first
        print(Entity.children.first?.name)
        print(self.Entity?.name)
        self.ID = ID
    }
    
    func spawnObject(rContent: RealityViewContent?, lighting:EnvironmentResource? ,position:SIMD3<Float>) {
        
        initiatePhysicsBody()
        initiateLighting(IBL: lighting!)
        
    }
    
    func initiatePhysicsBody() {
        
        guard let entity = Entity else { print("didnt work"); return }

        
        entity.generateCollisionShapes(recursive: true)
        
        if let collisionComponent = entity.components[CollisionComponent.self] {
            print(entity.name)
            entity.components[PhysicsBodyComponent.self] = .init(PhysicsBodyComponent(
                shapes: collisionComponent.shapes,
                mass: 1,
                material: .generate(staticFriction: 0.8, dynamicFriction: 0.8, restitution: 0.05),
                mode: .dynamic
            ))
        }
        
        
//        entity.components[PhysicsBodyComponent(shapes: entity.components[CollisionComponent.self]?.shapes, mass: 1)]
        
        entity.components[PhysicsMotionComponent.self] = .init()
        
        entity.components[PhysicsBodyComponent.self]?.isAffectedByGravity = true
        
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
