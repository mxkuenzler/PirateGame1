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
        
        super.init(Model: FloorModel!, id: ID.SECOND_OCEAN_FLOOR)
    }
}

class secondOceanFloor: Floor {
    init() async {
        let FloorModel = try? await Entity(named: "Ocean", in: realityKitContentBundle)
        
        super.init(Model: FloorModel!, id: ID.OCEAN_FLOOR)
        
        setPosition(pos: SIMD3<Float>(0,-10,0))
    }
}

class IslandFloor: Floor {
    init() async {
        let FloorModel = try? await Entity(named: "island", in: realityKitContentBundle)
        
        super.init(Model: FloorModel!, id: ID.ISLAND_FLOOR)
        
        await playAudio()
    }
    func playAudio() async {
        let fileName = "/Root/AmbientAudio/AtmospheresOcean"
        let resource = try? await AudioFileResource(named: fileName, from: "BackgroundSFX.usda",in:realityKitContentBundle)
        
        let controller = try? await Entity(named: "BackgroundSFX", in: realityKitContentBundle)
        let audioController = await controller?.findEntity(named: "AmbientAudio")
        rContent?.add(controller!)
        
        let ac = await audioController?.prepareAudio(resource!)
        await ac?.play()
    }
}

class DockFloor: Floor {
    init() async {
        let FloorModel = try? await Entity(named: "Dock", in: realityKitContentBundle)
        
        super.init(Model: FloorModel!, id: ID.DOCK_FLOOR)
        
        setPosition(pos: SIMD3<Float>(-8.5,0.1,0))
        setOrientation(angle: Float.pi/2, axes: SIMD3<Float>(1,0,0))
    }
}
