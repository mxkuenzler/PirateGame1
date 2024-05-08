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
    
    private var Model:ModelEntity?
    private var ID:Int?
    
    init(Model: ModelEntity, ID: Int) {
        self.Model = Model
        self.ID = ID
    }
    
    func spawnObject(rContent: RealityViewContent?, lighting:EnvironmentResource? ,position:SIMD3<Float>) {
        
        initiatePhysicsBody()
        initiateLighting(IBL: lighting!)
        
    }
    
    func initiatePhysicsBody() {
        
        guard let model = Model else { return }
        
        model.components[PhysicsBodyComponent.self] = .init(PhysicsBodyComponent(
            shapes: [ShapeResource.generateBox(size: SIMD3<Float>(x: 1, y: 1, z: 1))],
            mass: 1.0,
            mode: .static
        ))
        
        
        model.components[PhysicsMotionComponent.self] = .init()
        
        
    }
    
    func initiateLighting(IBL: EnvironmentResource) {
        
        let iblComponent = ImageBasedLightComponent(source: .single(IBL), intensityExponent: 0.25)
        guard let model = Model else { return }
            model.components.set(iblComponent)
            model.components.set(ImageBasedLightReceiverComponent(imageBasedLight: model))
        
        
    }
    
    static func ==(lhs: Object, rhs: Object) -> Bool {
        if lhs.getModel() == rhs.getModel(){
            return true
        }
        return false
    }
    
    func getModel() -> ModelEntity? {
        return Model
    }
    
    
    
}