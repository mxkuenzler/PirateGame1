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
        self.ID = ID
    }
    
    init(ModelEntity: ModelEntity, ID: ID) {
        self.Entity = ModelEntity as Entity
        self.ID = ID
    }
    
    func spawnObject(rContent: RealityViewContent?, lighting:EnvironmentResource? ,position:SIMD3<Float>) {
        
        initiatePhysicsBody()
        initiateLighting(IBL: lighting!)
        
    }
    
    func displayObject(lighting:EnvironmentResource?) {
        
        initiateLighting(IBL: lighting!)
        rContent?.add(getEntity()!)
        
    }
    
    func initiatePhysicsBody() {
        
        
        
        Entity?.generateCollisionShapes(recursive: true)
        
        Entity?.components[PhysicsMotionComponent.self] = .init()

        Entity?.components.set((PhysicsBodyComponent(
            massProperties: .default,
            //material: .generate(staticFriction: 0, dynamicFriction: 0, restitution: 0),
            mode: .static)))

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
    
    func setEntity(entity: ModelEntity) {
        Entity = entity
    }
    
    func getID() -> ID? {
        return ID
    }
    
    func handleCollision(event: CollisionEvents.Began) {
        //override in classes
    }
    
    func getPosition() -> SIMD3<Float>? {
        return Entity?.position
    }
    
    func setPosition(pos:SIMD3<Float>) {
        Entity?.position = pos
    }
    
    func setPosition(pos:SIMD3<Float>, relativeTo: Entity) {
        Entity?.setPosition(pos, relativeTo: relativeTo)
    }
    
    func goToSpawn() {
        Entity?.setPosition(SIMD3<Float>(0,1,0), relativeTo: Entity!)
    }
    
    func setOrientation(angle: Float, axes:SIMD3<Float>) {
        
        Entity?.setOrientation(simd_quatf(angle: angle, axis: axes), relativeTo: Entity!)
    
    }
    
    func onRegister() {
        //override
    }
    
}