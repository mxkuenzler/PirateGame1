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
    
    init(Model: Entity, id: ID){
        
                
        super.init(Entity: Model, ID: id)
        
        //self.getEntity()?.components.set(InputTargetComponent())

        //Model.components[InputTargetComponent.self]?.isEnabled = false
        
    }
}

class OceanFloor: Floor {
    init() async {
        let FloorModel = try? await Entity(named: "Ocean", in: realityKitContentBundle)
        
        super.init(Model: FloorModel!, id: ID.OCEAN_FLOOR)
    }
}

class IslandFloor: Floor {
    init() async {
        let FloorModel = try? await Entity(named: "Island", in: realityKitContentBundle)
        
        super.init(Model: FloorModel!, id: ID.ISLAND_FLOOR)
    }
}
