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
        
//        initiatePhysicsBody(rContent)
//        initiateLighting(lighting)
        
    }
    
    
    
    
    
    
    
}
