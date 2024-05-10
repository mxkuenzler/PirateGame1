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
    
    init(Model: ModelEntity, id: ID){
        
                
        super.init(Entity: Model, ID: id)
        
        Model.components[InputTargetComponent.self]?.isEnabled = false
        
    }
}

class OceanFloor: Floor {
    init(){
        let FloorModel = ModelEntity(mesh: .generatePlane(width: 50, depth: 50), materials: [OcclusionMaterial()])
        
        super.init(Model: FloorModel, id: ID.OCEAN_FLOOR)
        self.getEntity()?.setPosition(SIMD3<Float>(x: 0, y: -1, z: 0), relativeTo: self.getEntity())

    }
}

class IslandFloor: Floor {
    init(){
        let FloorModel = ModelEntity(mesh: .generateCylinder(height: 0.199, radius: 7.999), materials: [OcclusionMaterial()])
        
        super.init(Model: FloorModel, id: ID.ISLAND_FLOOR)
    }
}
