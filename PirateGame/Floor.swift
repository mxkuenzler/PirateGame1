//
//  Floor.swift
//  PirateGame
//
//  Created by Maxwell Kuenzler on 5/8/24.
//

import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI

class Floor: Object{
    
    init(){
        
        let FloorModel = ModelEntity(mesh: .generatePlane(width: 20, depth: 20), materials: [OcclusionMaterial()])
                
        super.init(Model: FloorModel, ID: ID.FLOOR)
        
        FloorModel.components[InputTargetComponent.self]?.isEnabled = false
        
        self.getModel()?.setPosition(SIMD3<Float>(x: 0, y: -0.001, z: 0), relativeTo: self.getModel())
    }
}
